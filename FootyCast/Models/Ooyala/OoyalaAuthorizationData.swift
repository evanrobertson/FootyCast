//
//  OoyalaAuthorizationData.swift
//  FootyCast
//
//  Created by Evan Robertson on 14/3/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import Foundation

struct OoyalaAuthorizationData: Decodable {
    
    /// videoInformation is not a 1-1 match with the response JSON, this is keyed
    /// by the video's id in the returned data
    let videoInformation: OoyalaVideoInformation
}
