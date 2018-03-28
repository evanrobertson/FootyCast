//
//  Ooyala.swift
//  FootyCast
//
//  Created by Evan Robertson on 12/3/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import Moya

enum Ooyala {
    /// secureToken
    /// - providerCoder:
    /// - videoId:
    /// - embedToken: Embed token returned from `AFL .session`
    case secureToken(String, String, String?)
    
    /// playlists
    /// - playlistUrl
    /// - playlistQuery
    case playlists(String, String)
}

extension Ooyala : TargetType {
    var baseURL: URL {
        switch self {
        case .secureToken(_, _, _):
            return URL(string: "http://player.ooyala.com/sas/player_api/v1")!
            
        case let .playlists(playlistUrl, _):
            return URL(string: playlistUrl)!
        }
    }
    
    var path: String {
        switch self {
        case let .secureToken(providerCode, videoId, _):
            return "authorization/embed_code/\(providerCode)/\(videoId)"
            
        default:
            return ""
        }
    }
    
    var method: Method {
        return .get
    }
    
    var sampleData: Data {
        let url = Bundle.main.url(forResource: "secure_token", withExtension: "json")!
        return try! Data.init(contentsOf: url, options: Data.ReadingOptions.mappedIfSafe)
    }
    
    var task: Task {
        switch self {
        case let .secureToken(_, _, embedToken):
            var params: [String: Any] = [:]
            params["device"] = "html5"
            params["domain"] = "http://www.ooyala.com"
            params["supportedFormats"] = "m3u8"
            if let embedToken = embedToken {
                params["embedToken"] = embedToken
            }
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case let .playlists(_, query):
            let arr = query.components(separatedBy:"&")
            var data = [String:Any]()
            for row in arr {
                let pairs = row.components(separatedBy:"=")
                data[pairs[0]] = pairs[1]
            }
            
            return .requestParameters(parameters: data, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
    
    
}
