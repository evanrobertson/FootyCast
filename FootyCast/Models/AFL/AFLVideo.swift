//
//  AFLVideo.swift
//  FootyCast
//
//  Created by Evan Robertson on 16/3/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import Foundation

protocol AFLVideo {
    var title: String { get }
    var subscriptionRequired: Bool { get }
    func getAttribute(key: String) -> String?
}

extension AFLVideo {
    subscript(key: String) -> String? {
        return getAttribute(key: key)
    }
}
