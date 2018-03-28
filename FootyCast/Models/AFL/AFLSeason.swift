//
//  AFLSeason.swift
//  FootyCast
//
//  Created by Evan Robertson on 14/3/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import Foundation

struct AFLSeason: Decodable {
    let id: String
    let name: String
    let shortName: String
    let roundPhase: String
    let currentRoundId: String
    let matchCentreUrl: String?
    let year: Int
    let rounds: [AFLRound]
}
