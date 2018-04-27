//
//  VideoPlayerCoordinator.swift
//  FootyCast
//
//  Created by Evan Robertson on 15/3/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import UIKit
import Hydra
import Moya
import SwiftyUserDefaults
import AVKit
import Valet
import GoogleCast

class VideoPlayerCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    weak var delegate: VideoPlayerCoordinatorDelegate?
    
    private let stubbing: Stubbing
    
    private lazy var aflProvider: MoyaProvider<AFL> = {
        return MoyaProvider<AFL>(withGlobalStubbing: stubbing)
    }()
    
    private lazy var bigpondProvider: MoyaProvider<Bigpond> = {
        return MoyaProvider<Bigpond>(withGlobalStubbing: stubbing)
    }()
    
    private lazy var ooyalaProvider: MoyaProvider<Ooyala> = {
        return MoyaProvider<Ooyala>(withGlobalStubbing: stubbing)
    }()
    
    private lazy var valet: Valet = {
       return Valet.valet(with: Identifier(nonEmpty: Bundle.main.bundleIdentifier!)!, accessibility: Accessibility.whenUnlocked)
    }()
    
    init(stubbing: Stubbing) {
        self.stubbing = stubbing
    }
    
    func castVideo(url: String, finishedLoading: @escaping () -> ()) {
        
        let mediaInfo = GCKMediaInformation(contentID: url,
                                            streamType: .buffered,
                                            contentType: "application/x-mpegurl",
                                            metadata: nil,
                                            streamDuration: 0,
                                            mediaTracks: nil,
                                            textTrackStyle: nil,
                                            customData: nil)
        
        if let session = GCKCastContext.sharedInstance().sessionManager.currentSession {
            session.remoteMediaClient?.loadMedia(mediaInfo)
        }
        
        finishedLoading()
    }
    
    func showVideo(_ video: AFLVideo, onViewController viewController: UIViewController, finishedLoading: @escaping () -> ()) throws {
        var videoId: String
        
        if let ooyalaId = video["ooyala embed code"] {
            videoId = ooyalaId
        } else if let stateId = video["state-VIC"] {
            videoId = stateId
        } else if let hevcId = video["hevcEmbedCode-state-VIC"] {
            videoId = hevcId
        } else {
            throw VideoPlayerCoordinatorError.noVideoId
        }
        
        async(in: .background, { _ -> (String) in
            let mediaToken = try await(self.aflProvider.request(.mediaToken(), AFLMediaToken.self))
            var aflToken: String
            
            if let appToken = self.valet[.appToken] {
                aflToken = appToken
            } else {
                // Get user data from keychain
                guard let username = self.valet[.username],
                    let password = self.valet[.password] else {
                        throw VideoPlayerCoordinatorError.noCredentials
                }
                
                aflToken = try await(AFLAuthentication().getToken(username: username, password: password, mediaToken: mediaToken.token))
            }
            
            // If a sub is required we get an embed token, otherwise we can skip it
            var embedToken: String?
            if video.subscriptionRequired {
                let embedTokenModel = try await(
                    self.aflProvider.request(.embedToken(mediaToken.token, aflToken, videoId), AFLEmbedToken.self))
                embedToken = embedTokenModel.token
            }
            
            let secureToken = try await(
                self.ooyalaProvider.request(
                    .secureToken("Zha2IxOrpV-sPLqnCop1Lz0fZ5Gi", videoId, embedToken),
                    OoyalaSecureToken.self))
            
            guard let stream = secureToken.authorizationData.videoInformation.streams.first,
                let data = Data(base64Encoded: stream.url.data),
                let secureUrl = String(data: data, encoding: .utf8) else {
                    // TODO: Throw an error
                    return ""
            }
            
            return secureUrl
        }).then({ secureUrl in
            
            if GCKCastContext.sharedInstance().sessionManager.currentSession != nil {
                self.castVideo(url: secureUrl, finishedLoading: finishedLoading)
                return
            }
            
            print(secureUrl)
            
            let url = URL(string: secureUrl)!
            let player = AVPlayer(url: url)
            player.allowsExternalPlayback = true
            player.usesExternalPlaybackWhileExternalScreenIsActive = true
            
            let playerController = AVPlayerViewController()
            playerController.player = player
            
            finishedLoading()
            
            viewController.present(playerController, animated: true, completion: {
                // TODO: Check what airplay stuff is needed
                // Can possibly clean this up
                player.play()
                try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try! AVAudioSession.sharedInstance().setActive(true)
            })
            
        }).catch({ error in
            self.delegate?.videoPlayerCoordinator(self, failedWithError: error)
        })
    }
}

enum VideoPlayerCoordinatorError: Error {
    case noVideoId, noCredentials
}

protocol VideoPlayerCoordinatorDelegate: class {
    func videoPlayerCoordinator(_ videoPlayerCoordinator: VideoPlayerCoordinator,
                                failedWithError error: Error)
}
