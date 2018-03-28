//
//  OoyalaSecureToken.swift
//  FootyCast
//
//  Created by Evan Robertson on 14/3/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import Foundation

struct OoyalaSecureToken: Decodable {
    let authorizationData: OoyalaAuthorizationData
    
    enum CodingKeys: String, CodingKey {
        case authorizationData = "authorization_data"
    }
    
    /// Due to the structure of the JSON we need to grab the first video information
    /// and pass that to the Authorization Data, the JSON key for the video information
    /// is the video's id and will be different for all the videos
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let videoInfo = try values.decode([String: OoyalaVideoInformation].self, forKey: .authorizationData)
        authorizationData = OoyalaAuthorizationData(videoInformation: videoInfo.first!.value)
    }
}
