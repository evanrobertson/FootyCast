//
//  AFLAttribute.swift
//  FootyCast
//
//  Created by Evan Robertson on 14/3/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import Foundation

struct AFLAttribute: Decodable {
    let attrName: String
    let attrValue: String
    let mediaId: String?
    let attributeId: String?
    let attrKey: String?
    let guid: String?
}
