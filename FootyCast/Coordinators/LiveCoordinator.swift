//
//  LiveCoordinator.swift
//  FootyCast
//
//  Created by Evan Robertson on 25/2/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import UIKit
import AVKit
import Hydra
import Moya
import SwiftyUserDefaults

class LiveCoordinator : RootViewCoordinator {
    var childCoordinators: [Coordinator] = []
    
    var rootViewController: UIViewController {
        return navigationController
    }
    
    private let stubbing: Stubbing
    
    private lazy var navigationController: UINavigationController = {
        return UINavigationController(rootViewController: liveVideosViewController)
    }()
    
    private lazy var liveVideosViewController: LiveVideosTableViewController = {
        return StoryboardScene.Live.liveVideosTableViewController.instantiate()
    }()
    
    // MARK: - Moya Providers
    
    private lazy var aflProvider: MoyaProvider<AFL> = {
        return MoyaProvider<AFL>(withGlobalStubbing: stubbing)
    }()
    
    private lazy var bigpondProvider: MoyaProvider<Bigpond> = {
        return MoyaProvider<Bigpond>(withGlobalStubbing: stubbing)
    }()
    
    private lazy var ooyalaProvider: MoyaProvider<Ooyala> = {
        return MoyaProvider<Ooyala>(withGlobalStubbing: stubbing)
    }()
    
    // MARK: - Init
    
    init(stubbing: Stubbing) {
        self.stubbing = stubbing
    }
    
    func start() {
        liveVideosViewController.delegate = self
        
        liveVideosViewController.setLoading(true)
        getLiveVideos().then { videos in
            self.liveVideosViewController.liveVideos = videos
        }.always(in: .main) {
            self.liveVideosViewController.setLoading(false)
        }
    }
    
    private func showLiveVideo(_ video: AFLLiveVideo) {
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
        } catch VideoPlayerCoordinatorError.noCredentials {
            // Dismiss indicator, show error
            self.rootViewController.dismiss(animated: true, completion: {
                UIAlertController.showOkAlert("No Credentials",
                                              message: "Please add your credentials in the settings",
                                              controller: self.rootViewController,
                                              okCompletion: {})
            })
        } catch {
            // Dismiss indicator, show error
            self.rootViewController.dismiss(animated: true, completion: {
                self.removeChildCoordinator(childCoordinator: videoPlayerCoordinator)
                UIAlertController.showOkAlert("Could not load video",
                                              message: "Please try again",
                                              controller: self.rootViewController,
                                              okCompletion: {})
            })
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
    
    // MARK: - Data
    
    internal func getLiveVideos() -> Promise<[AFLLiveVideo]> {
        return async { _ -> ([AFLLiveVideo]) in
            let mediaToken = try await(self.aflProvider.request(.mediaToken(), AFLMediaToken.self))
            let liveVideos = try await(self.aflProvider.request(.liveVideo(mediaToken.token), [AFLLiveVideo].self))
            return liveVideos
        }
    }
}

//MARK: - LiveVideosTableViewControllerDelegate

extension LiveCoordinator: LiveVideosTableViewControllerDelegate {
    func liveVideosTableViewController(
        _ liveVideosTableViewController: LiveVideosTableViewController,
        didSelectLiveVideo liveVideo: AFLLiveVideo) {
        showLiveVideo(liveVideo)
    }
    
    func reloadLiveVideosTableViewController(_ liveVideosTableViewController: LiveVideosTableViewController) {
        liveVideosTableViewController.setLoading(true)
        getLiveVideos().then { videos in
            liveVideosTableViewController.liveVideos = videos
        }.always(in: .main) {
            liveVideosTableViewController.setLoading(false)
        }
    }
}

// MARK: - VideoPlayerCoordinatorDelegate

extension LiveCoordinator: VideoPlayerCoordinatorDelegate {
    func videoPlayerCoordinator(_ videoPlayerCoordinator: VideoPlayerCoordinator, failedWithError error: Error) {
        handleVideoPlayerError(error: error)
    }
}

