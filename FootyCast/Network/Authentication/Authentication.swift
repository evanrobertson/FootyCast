//
//  Authentication.swift
//  FootyCast
//
//  Created by Evan Robertson on 24/3/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import Foundation
import Hydra
import Moya
import SwiftyUserDefaults
import Valet

struct AFLAuthentication {
    let aflProvider = MoyaProvider<AFL>()
    let bigpondProvider = MoyaProvider<Bigpond>()
    let valet = Valet.sharedAccessGroupValet(with: Identifier(nonEmpty: Bundle.main.bundleIdentifier!)!, accessibility: .whenUnlocked)
    
    func getToken(username: String, password: String, mediaToken: String, clearCache: Bool = false) -> Promise<String> {
        
        if clearCache {
            Defaults.remove(.aflToken)
        }
        
        // If a token was set on the settings screen we use that
        if let keychainToken = self.valet[.appToken] {
            return Promise(resolved: keychainToken)
        }
        
        return async({ _ -> String in
            
            // Get cached token
            if let cachedToken = Defaults[.aflToken] {
                return cachedToken
            }
            
            // Get a fresh token
            let auth = try await(
                self.bigpondProvider.request(
                    .authenticate(mediaToken, username, password),
                    BigpondAuthentication.self))
            
            let session = try await(self.aflProvider.request(.session(mediaToken, auth.data.artifactValue), AFLUuid.self))
            let aflToken = session.uuid
            Defaults[.aflToken] = aflToken
            
            return aflToken
        })
    }
}
