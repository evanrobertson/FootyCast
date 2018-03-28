//
//  OoyalaVideoInformation.swift
//  FootyCast
//
//  Created by Evan Robertson on 14/3/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import Foundation

struct OoyalaVideoInformation: Decodable {
    let authorized: Bool
    let streams: [OoyalaStream]
}
