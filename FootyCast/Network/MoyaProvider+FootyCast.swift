//
//  MoyaProvider+FootyCast.swift
//  FootyCast
//
//  Created by Evan Robertson on 14/3/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import Moya
import Hydra

enum Stubbing {
    case never, all, afl, bigpond, ooyala
}

extension MoyaProvider {
    
    /// Perform a request and deserialize to a Decodable
    /// - Parameter target: The action to be performed
    /// - Parameter type: The Decodable to be deserialized into
    /// - Returns: Promise with the specified Decodable type
    func request<T: Decodable>(_ target: Target, _ type: T.Type) -> Promise<T> {
        return Promise<T>.init(in: .background) { (resolve, reject, _) in
            self.request(target, completion: { (result) in
                switch result {
                case let .success(moyaResponse):
                    do {
                        let object = try moyaResponse.map(T.self)
                        resolve(object)
                    } catch {
                        reject(error)
                    }
                    break
                    
                case let .failure(error):
                    reject(error)
                    break
                }
            })
        }
    }
}

extension MoyaProvider {
    convenience init(withGlobalStubbing stubbing: Stubbing) {
        var stubBehaviour: StubBehavior = .never
        
        switch stubbing {
        case .never:
            break
            
        case .all:
            stubBehaviour = .immediate
            break
            
        case .afl:
            stubBehaviour = Target.self == AFL.self ? .immediate : .never
            break
            
        case .bigpond:
            stubBehaviour = Target.self == Bigpond.self ? .immediate : .never
            break
            
        case .ooyala:
            stubBehaviour = Target.self == Ooyala.self ? .immediate : .never
            break
        }
        
        self.init(stubClosure: { (Target) -> StubBehavior in
            return stubBehaviour
        })
    }
}
