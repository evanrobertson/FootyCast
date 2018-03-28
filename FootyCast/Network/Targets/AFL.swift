//
//  AFL.swift
//  FootyCast
//
//  Created by Evan Robertson on 11/3/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import Moya

enum AFL {
    /// embedToken
    /// - mediaToken:
    /// - userToken:
    /// - videoId:
    case embedToken(String, String, String)
    
    /// liveVideo
    /// - mediaToken:
    case liveVideo(String)
    
    /// Used in the header field `x-media-mis-token` on most requests
    case mediaToken()
    
    /// round
    /// - mediaToken:
    /// - roundId
    case round(String, String)
    
    /// List of seasons with rounds
    /// - mediaToken:
    case seasons(String)
    
    /// session
    /// - mediaToken:
    /// - sessionId:
    case session(String, String)
    
    /// users
    /// - mediaToken:
    case users(String)
}

// TODO: Extend TargetTypes to reference the type they will decode to

extension AFL: TargetType {
    var baseURL: URL {
        switch self {
        case .session(_),
             .users(_):
            return URL(string: "http://api.sub.afl.com.au/cfs-premium/users")!
            
        default:
            return URL(string: "http://api.afl.com.au/cfs")!
        }
    }
    
    var path: String {
        switch self {
        case let .embedToken(_, userToken, _):
            return "users/\(userToken)/token"
        case .mediaToken:
            return "afl/WMCTok"
            
        case .liveVideo(_):
            return "afl/liveMedia"
            
        case let .round(_, roundId):
            return "afl/videos/round/\(roundId)"
            
        case .seasons(_):
            return "afl/seasons"
            
        case .session(_):
            return "session"
    
        case .users(_):
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .mediaToken,
             .users(_):
            return .post
            
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .embedToken(_, _, _):
            let url = Bundle.main.url(forResource: "embed_token", withExtension: "json")!
            return try! Data.init(contentsOf: url, options: Data.ReadingOptions.mappedIfSafe)
            
        case .liveVideo(_):
            let url = Bundle.main.url(forResource: "live_response", withExtension: "json")!
            return try! Data.init(contentsOf: url, options: Data.ReadingOptions.mappedIfSafe)
            
        case .mediaToken():
            let url = Bundle.main.url(forResource: "media_token", withExtension: "json")!
            return try! Data.init(contentsOf: url, options: Data.ReadingOptions.mappedIfSafe)
            
        case .round(_, _):
            let url = Bundle.main.url(forResource: "round_videos", withExtension: "json")!
            return try! Data.init(contentsOf: url, options: Data.ReadingOptions.mappedIfSafe)
            
        case .seasons(_):
            let url = Bundle.main.url(forResource: "seasons", withExtension: "json")!
            return try! Data.init(contentsOf: url, options: Data.ReadingOptions.mappedIfSafe)
            
        case .session(_):
            let url = Bundle.main.url(forResource: "session", withExtension: "json")!
            return try! Data.init(contentsOf: url, options: Data.ReadingOptions.mappedIfSafe)
            
        case .users(_):
            return "".data(using: .utf8)!
        }
    }
    
    var task: Task {
        switch self {
        case let .embedToken(_, _, videoId):
            var params: [String : Any] = [:]
            params["embedCode"] = videoId
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .liveVideo(_):
            var params: [String : Any] = [:]
            params["org"] = "AFL"
            params["view"] = "full"
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .round(_, _):
            var params: [String: Any] = [:]
            params["pageSize"] = 50
            params["pageNum"] = 1
            params["categories"] = "Match Replays"
            params["includeOnlineVideo"] = false
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case let .session(_, sessionId):
            var params: [String: Any] = [:]
            params["sessionId"] = sessionId // TODO: Needs encoding
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .users(_):
            return .requestCompositeParameters(bodyParameters: [:],
                                               bodyEncoding: URLEncoding.httpBody,
                                               urlParameters: ["paymentMethod": "ONE_PLACE"])
            
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case let .embedToken(mediaToken, _, _),
             let .liveVideo(mediaToken),
             let .round(mediaToken, _),
             let .seasons(mediaToken),
             let .session(mediaToken, _),
             let .users(mediaToken):
            return ["x-media-mis-token": mediaToken]
            
        default:
            return [:]
        }
    }
}

protocol MoyaDecodable {
    
}


