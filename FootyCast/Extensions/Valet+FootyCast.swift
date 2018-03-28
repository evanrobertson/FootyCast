//
//  Valet+FootyCast.swift
//  FootyCast
//
//  Created by Evan Robertson on 17/3/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import Valet

enum ValetKey: String {
    case username, password, subscriptionType, appToken
}

extension Valet {
    subscript(key: ValetKey) -> String? {
        get {
            return string(forKey: key.rawValue)
        }
        
        set(newValue) {
            if let newValue = newValue,
                !newValue.isEmpty {
                set(string: newValue, forKey: key.rawValue)
            } else {
                removeObject(forKey: key.rawValue)
            }
        }
    }
}
