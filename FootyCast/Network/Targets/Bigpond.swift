//
//  Bigpond.swift
//  FootyCast
//
//  Created by Evan Robertson on 11/3/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import Moya

enum Bigpond {
    /// authenticate
    /// - mediaToken:
    /// - username:
    /// - password:
    case authenticate(String, String, String)
}

extension Bigpond: TargetType {
    var baseURL: URL {
        return URL(string: "https://services.bigpond.com/rest/v1")!
    }
    
    var path: String {
        switch self {
        case .authenticate(_, _, _):
            return "AuthenticationService/authenticate"
        }
    }
    
    var method: Method {
        return .post
    }
    
    var sampleData: Data {
        switch self {
        case .authenticate(_, _, _):
            let url = Bundle.main.url(forResource: "bigpond_auth", withExtension: "json")!
            return try! Data.init(contentsOf: url, options: Data.ReadingOptions.mappedIfSafe)
        }
    }
    
    var task: Task {
        switch self {
        case let .authenticate(_, username, password):
            var params: [String:Any] = [:]
            params["userIdentifier"] = username
            params["authToken"] = password
            params["userIdentifierType"] = "EMAIL"
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case let .authenticate(mediaToken, _, _):
            return [
                "User-Agent": "Dalvik/2.1.0 (Linux; U; Android 6.0; HTC_0PJA10 Build/MRA58K)",
                "Authorization": "Basic QUZMb3dfZGV2aWNlOmFOVSNGNHJCU0dqbmtANEZXM0Zt",
                "Content-Type": "application/x-www-form-urlencoded",
                "x-media-mis-token": mediaToken
            ]
        }
    }
}
