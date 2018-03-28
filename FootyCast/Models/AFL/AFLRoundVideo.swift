//
//  AFLReplayVideo.swift
//  FootyCast
//
//  Created by Evan Robertson on 14/3/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import Foundation

struct AFLRoundVideo: AFLVideo, Decodable {
    let title: String
    let description: String
    let externalId: String
    let publisher: String
    let programType: String
    let programCategory: String
    let thumbnailPath: String
    let entitlement: String?
    let sizeRestricted: Bool
    
    let customAttributes: [AFLAttribute]
    
    //    let customPublishDate: Date   // Date is in format "2017-09-30T04:00:10.000+0000", needs a custom handler
    //    let publishDate: Date         //
    
    var subscriptionRequired: Bool {
        guard let entitlement = self.entitlement else {
            return false
        }
        
        return !entitlement.isEmpty
    }
    
    func getAttribute(key: String) -> String? {
        return customAttributes.first(where: { $0.attrName == key })?.attrValue
    }
}
