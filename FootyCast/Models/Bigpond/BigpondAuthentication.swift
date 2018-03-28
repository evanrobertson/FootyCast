//
//  BigpondAuthentication.swift
//  FootyCast
//
//  Created by Evan Robertson on 14/3/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import Foundation

struct BigpondAuthentication: Decodable {
    let responseCode: Int
    let responseMessage: String
    let data: BigpondAuthenticationData
}
