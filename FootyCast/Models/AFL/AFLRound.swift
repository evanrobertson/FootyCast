//
//  AFLRound.swift
//  FootyCast
//
//  Created by Evan Robertson on 14/3/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import Foundation

struct AFLRound: Decodable {
    let roundId: String
    let seasonId: String
    let name: String
    let abbreviation: String
    let roundNumber: Int
}
