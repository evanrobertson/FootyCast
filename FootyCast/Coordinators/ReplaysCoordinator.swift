//
//  ReplaysCoordinator.swift
//  FootyCast
//
//  Created by Evan Robertson on 25/2/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import GoogleCast
import Hydra
import Moya
import UIKit

class ReplaysCoordinator: RootViewCoordinator {
    var childCoordinators: [Coordinator] = []

    var rootViewController: UIViewController {
        return navigationController
    }

    private let stubbing: Stubbing

    private lazy var navigationController: UINavigationController = {
        UINavigationController(rootViewController: replayTypesTableViewController)
    }()

    private lazy var replayTypesTableViewController: ReplayTypesTableViewController = {
        StoryboardScene.Replays.replayTypesTableViewController.instantiate()
    }()

    // MARK: - MoyaProviders

    private lazy var aflProvider: MoyaProvider<AFL> = {
        MoyaProvider<AFL>(withGlobalStubbing: stubbing)
    }()

    // MARK: - Init

    init(stubbing: Stubbing) {
        self.stubbing = stubbing
    }

    func start() {
        replayTypesTableViewController.delegate = self

        replayTypesTableViewController.setLoading(true)

        getAllSeasons().then { currentSeasonId, seasonTypes in
            self.replayTypesTableViewController.currentSeasonId = currentSeasonId
            self.replayTypesTableViewController.allSeasons = seasonTypes
        }.always(in: .main) {
            self.replayTypesTableViewController.setLoading(false)
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
        replayRoundVideosViewController.setLoading(true)
        replayRoundVideosViewController.delegate = self
        replayRoundVideosViewController.round = round
        navigationController.pushViewController(replayRoundVideosViewController, animated: true)

        getVideos(forRound: round)
            .then { videos in
                replayRoundVideosViewController.roundVideos = videos
            }.always(in: .main) {
                replayRoundVideosViewController.setLoading(false)
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
                self.rootViewController.dismiss(animated: true) {
                    let castState = GCKCastContext.sharedInstance().castState
                    if castState == .connected || castState == .connecting {
                        GCKCastContext.sharedInstance().presentDefaultExpandedMediaControls()
                    }
                }
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
        rootViewController.dismiss(animated: true, completion: {
            UIAlertController.showOkAlert(title,
                                          message: "Please try again",
                                          controller: self.rootViewController,
                                          okCompletion: {})
        })
    }
}

// MARK: Data

extension ReplaysCoordinator {
    internal func getAllSeasons() -> Promise<(String?, [SeasonType: [AFLSeason]])> {
        return async(in: .background) { _ -> (String?, [SeasonType: [AFLSeason]]) in

            let mediaToken = try await(self.aflProvider.request(.mediaToken(), AFLMediaToken.self))
            let wrapper = try await(self.aflProvider.request(.seasons(mediaToken.token), AFLSeasonsWrapper.self))

            let premiershipSeasons = wrapper.seasons
                .filter({ $0.name.lowercased().contains("premiership") })
                .sorted(by: { $0.year >= $1.year })
            let preseasonSeasons = wrapper.seasons
                .filter({ !$0.name.lowercased().contains("premiership") })
                .sorted(by: { $0.year >= $1.year })

            return (wrapper.currentSeasonId,
                    [
                        .premiership: premiershipSeasons,
                        .preseason: preseasonSeasons,
            ])
        }
    }

    internal func getVideos(forRound round: AFLRound) -> Promise<[AFLRoundVideo]> {
        return async(in: .background) { _ -> [AFLRoundVideo] in

            let mediaToken = try await(self.aflProvider.request(.mediaToken(), AFLMediaToken.self))
            let roundCategories = try await(self.aflProvider.request(.round(mediaToken.token, round.roundId), AFLRoundCategoriesWrapper.self))

            guard let videos = roundCategories.categories.first?.videos else {
                return []
            }

            return videos
        }
    }
}

// MARK: - ReplayTypesTableViewControllerDelegate

extension ReplaysCoordinator: ReplayTypesTableViewControllerDelegate {
    func replayTypesTableViewController(_: ReplayTypesTableViewController,
                                        didSelectSeason season: AFLSeason) {
        showRounds(forSeason: season)
    }

    func replayTypesTableViewControllerRefreshData(_ replayTypesTableViewController: ReplayTypesTableViewController) {
        replayTypesTableViewController.setLoading(true)

        getAllSeasons().then { currentSeasonId, seasonTypes in
            self.replayTypesTableViewController.currentSeasonId = currentSeasonId
            self.replayTypesTableViewController.allSeasons = seasonTypes
        }.always(in: .main) {
            self.replayTypesTableViewController.setLoading(false)
        }
    }
}

// MARK: - ReplayRoundsTableViewControllerDelegate

extension ReplaysCoordinator: ReplayRoundsTableViewControllerDelegate {
    func replayRoundsTableViewController(_: ReplayRoundsTableViewController,
                                         didSelectRound round: AFLRound) {
        showVideos(forRound: round)
    }
}

// MARK: - ReplayRoundVideosViewControllerDelegate

extension ReplaysCoordinator: ReplayRoundVideosViewControllerDelegate {
    func replayRoundVideosViewController(_: ReplayRoundVideosViewController,
                                         didSelectVideo video: AFLRoundVideo) {
        showVideo(video)
    }

    func replayRoundVideosViewController(_ replayRoundVideosViewController: ReplayRoundVideosViewController,
                                         refreshRound round: AFLRound) {
        replayRoundVideosViewController.setLoading(true)

        getVideos(forRound: round)
            .then { videos in
                replayRoundVideosViewController.roundVideos = videos
            }.always(in: .main) {
                replayRoundVideosViewController.setLoading(false)
            }
    }
}

// MARK: - VideoPlayerCoordinatorDelegate

extension ReplaysCoordinator: VideoPlayerCoordinatorDelegate {
    func videoPlayerCoordinator(_: VideoPlayerCoordinator, failedWithError error: Error) {
        handleVideoPlayerError(error: error)
    }
}
