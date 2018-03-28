//
//  AFLEmbedToken.swift
//  FootyCast
//
//  Created by Evan Robertson on 14/3/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import Foundation

struct AFLEmbedToken: Decodable {
    let token: String
    let embedCode: String
    let uuid: String
    
    // TODO: If we need this ever then check the type that is actually returned
    //    let marketSegment: String?
}
