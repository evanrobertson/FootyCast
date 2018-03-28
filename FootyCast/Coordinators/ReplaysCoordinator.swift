//
//  ReplaysCoordinator.swift
//  FootyCast
//
//  Created by Evan Robertson on 25/2/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import UIKit
import Moya
import Hydra
import GoogleCast

class ReplaysCoordinator : RootViewCoordinator {
    var childCoordinators: [Coordinator] = []
    
    var rootViewController: UIViewController {
        return navigationController
    }
    
    private let stubbing: Stubbing
    
    private lazy var navigationController: UINavigationController = {
        
        return UINavigationController(rootViewController: replayTypesTableViewController)
    }()
    
    private lazy var replayTypesTableViewController: ReplayTypesTableViewController = {
        return StoryboardScene.Replays.replayTypesTableViewController.instantiate()
    }()
    
    // MARK: - MoyaProviders
    
    private lazy var aflProvider: MoyaProvider<AFL> = {
        return MoyaProvider<AFL>(withGlobalStubbing: stubbing)
    }()
    
    // MARK: - Init
    
    init(stubbing: Stubbing) {
        self.stubbing = stubbing
    }
    
    func start() {
        replayTypesTableViewController.delegate = self
        
        async(in: .background) { (_) -> AFLSeasonsWrapper in
            let mediaToken = try await(self.aflProvider.request(.mediaToken(), AFLMediaToken.self))
            return try await(self.aflProvider.request(.seasons(mediaToken.token), AFLSeasonsWrapper.self))
        }.then { seasonWrapper in
            
            // Any seasons that aren't "premiership" are preseasons (NAB, JLT)
            let premiershipSeasons = seasonWrapper.seasons
                .filter({ $0.name.lowercased().contains("premiership") })
                .sorted(by: { $0.year >= $1.year })
            let preseasonSeasons = seasonWrapper.seasons
                .filter({ !$0.name.lowercased().contains("premiership") })
                .sorted(by: { $0.year >= $1.year })
            
            // Pass the seasons to the replay types vc
            self.replayTypesTableViewController.currentSeasonId = seasonWrapper.currentSeasonId
            self.replayTypesTableViewController.setSeasons(seasons: premiershipSeasons, forType: .premiership)
            self.replayTypesTableViewController.setSeasons(seasons: preseasonSeasons, forType: .preseason)
        }.catch { error in
            print(error)
        }
    }
    
    internal func showRounds(forSeason season: AFLSeason) {
        var rounds = season.rounds
        
        // Only get rounds that are the current rounds or before the current round
        if let currentRound = rounds.first(where: { $0.roundId == season.currentRoundId }) {
            rounds = rounds.filter({ $0.roundNumber <= currentRound.roundNumber })
        }
        
        let orderedRounds = rounds.sorted(by: { $0.roundNumber >= $1.roundNumber })
        
        let replayRoundsTableViewController = StoryboardScene.Replays.replayRoundsTableViewController.instantiate()
        replayRoundsTableViewController.delegate = self
        replayRoundsTableViewController.title = "\(season.year) \(season.shortName)"
        replayRoundsTableViewController.rounds = orderedRounds
        
        navigationController.pushViewController(replayRoundsTableViewController, animated: true)
    }
    
    internal func showVideos(forRound round: AFLRound) {
        let replayRoundVideosViewController = StoryboardScene.Replays.replayRoundVideosViewController.instantiate()
        replayRoundVideosViewController.delegate = self
        navigationController.pushViewController(replayRoundVideosViewController, animated: true)
        
        // TODO: Add loading indicators
        
        async(in: .background) { _ -> [AFLRoundVideo] in
            
            let mediaToken = try await(self.aflProvider.request(.mediaToken(), AFLMediaToken.self))
            let roundCategories = try await(self.aflProvider.request(.round(mediaToken.token, round.roundId), AFLRoundCategoriesWrapper.self))
            
            guard let videos = roundCategories.categories.first?.videos else {
                // TODO: Throw an error
                return []
            }
            
            return videos
        }.then { videos in
            replayRoundVideosViewController.roundVideos = videos
        }.catch { error in
            // TODO: Handle error
            print(error)
        }.always {
            //TODO: Handle loading indicator stopped
        }
    }
    
    internal func showVideo(_ video: AFLVideo) {
        let videoPlayerCoordinator = VideoPlayerCoordinator(stubbing: stubbing)
        videoPlayerCoordinator.delegate = self
        
        // Show loading indicator
        let spinner = SpinnerViewController(title: "Loading Video", color: .black)
        rootViewController.present(spinner, animated: true, completion: nil)
        
        do {
            
            try videoPlayerCoordinator.showVideo(video, onViewController: rootViewController) {
                // Dismiss indicator
                self.rootViewController.dismiss(animated: true, completion: nil)
            }
        } catch {
            handleVideoPlayerError(error: error)
        }
    }
    
    internal func handleVideoPlayerError(error: Error) {
        var title = "Could not load video"
        
        switch error {
        case VideoPlayerCoordinatorError.noCredentials:
            title = "Please add your credentials in the settings"
            break
        default:
            break
        }
        
        // Dismiss loading indicator and show error message
        self.rootViewController.dismiss(animated: true, completion: {
            UIAlertController.showOkAlert(title,
                                          message: "Please try again",
                                          controller: self.rootViewController,
                                          okCompletion: {})
        })
    }
}

// MARK: - ReplayTypesTableViewControllerDelegate

extension ReplaysCoordinator: ReplayTypesTableViewControllerDelegate {
    func replayTypesTableViewController(_ replayTypesTableViewController: ReplayTypesTableViewController,
                                        didSelectSeason season: AFLSeason) {
        showRounds(forSeason: season)
    }
}

// MARK: - ReplayRoundsTableViewControllerDelegate

extension ReplaysCoordinator: ReplayRoundsTableViewControllerDelegate {
    func replayRoundsTableViewController(_ eeplayRoundsTableViewController: ReplayRoundsTableViewController,
                                         didSelectRound round: AFLRound) {
        showVideos(forRound: round)
    }
}

// MARK: - ReplayRoundVideosViewControllerDelegate

extension ReplaysCoordinator: ReplayRoundVideosViewControllerDelegate {
    func replayRoundVideosViewController(_ replayRoundVideosViewController: ReplayRoundVideosViewController,
                                         didSelectVideo video: AFLRoundVideo) {
        showVideo(video)
    }
}

// MARK: - VideoPlayerCoordinatorDelegate

extension ReplaysCoordinator: VideoPlayerCoordinatorDelegate {
    func videoPlayerCoordinator(_ videoPlayerCoordinator: VideoPlayerCoordinator, failedWithError error: Error) {
        handleVideoPlayerError(error: error)
    }
}
