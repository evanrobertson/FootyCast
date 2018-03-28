//
//  BigpondAuthenticationData.swift
//  FootyCast
//
//  Created by Evan Robertson on 14/3/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import Foundation

struct BigpondAuthenticationData: Decodable {
    let artifactName: String
    let artifactValue: String
    let FQUN: String?
    let amlbcookieValue: String?
}
