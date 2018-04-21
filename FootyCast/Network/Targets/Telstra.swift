//
//  Telstra.swift
//  FootyCast
//
//  Created by Evan Robertson on 24/3/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import Moya

enum Telstra {
    case sportsPass(String, String)
}

extension Telstra: TargetType {
    var baseURL: URL {
        return URL(string: "http://hub.telstra.com.au")!
    }

    var path: String {
        switch self {
        case .sportsPass:
            return "sp2017-afl-app"
        }
    }

    var method: Method {
        return .get
    }

    var sampleData: Data {
        return "".data(using: .utf8)!
    }

    var task: Task {
        switch self {
        case let .sportsPass(_, uuid):
            var params: [String: Any] = [:]
            params["tpUID"] = uuid
            params["type"] = "SportPassConfirmation"
            params["offerId"] = "a482eaad-9213-419c-ace2-65b7cae73317"

            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        switch self {
        case .sportsPass:
            return [
                "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
                "User-Agent": "Mozilla/5.0 (Linux; Android 6.0; HTC One_M8 Build/MRA58K.H15; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/56.0.2924.87 Mobile Safari/537.36",
                "Host": "hub.telstra.com.au",
                "Accept-Encoding": "gzip, deflate",
                "X-Requested-With": "com.telstra.android.afl",
            ]
        }
    }
}
