//
//  AFLTeam.swift
//  FootyCast
//
//  Created by Evan Robertson on 14/3/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import Foundation

struct AFLTeam: Decodable {
    let teamId: String
    let teamAbbr: String
    let teamName: String
    let teamNickname: String
}
