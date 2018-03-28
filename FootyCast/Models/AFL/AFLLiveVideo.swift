//
//  AFLLiveVideo.swift
//  FootyCast
//
//  Created by Evan Robertson on 14/3/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import Foundation

struct AFLLiveVideo: AFLVideo, Decodable {
    let title: String
    let matchId: String?
    let homeTeam: AFLTeam?
    let awayTeam: AFLTeam?
    let videoStream: AFLVideoStream?
    
    var subscriptionRequired: Bool {
        guard let entitlement = videoStream?.entitlement else {
            return false
        }
        
        return !entitlement.isEmpty
    }
    
    func getAttribute(key: String) -> String? {
        return videoStream?.getAttribute(forKey: key)
    }
}
