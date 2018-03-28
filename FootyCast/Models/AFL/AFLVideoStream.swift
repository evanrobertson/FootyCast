//
//  AFLVideoStream.swift
//  FootyCast
//
//  Created by Evan Robertson on 14/3/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import Foundation

struct AFLVideoStream: Decodable {
    let title: String
    let streamId: String
    let entitlement: String?
    let thumbnailUrl: String?
    let sizeRestricted: Bool
    let customAttributes: [AFLAttribute]
    
    func getAttribute(forKey key: String) -> String? {
        return customAttributes.first(where: { $0.attrName == key })?.attrValue
    }
}
