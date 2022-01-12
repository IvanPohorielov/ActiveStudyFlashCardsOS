//
//  API.swift
//  FlashCards
//
//  Created by Ivan Pohorielov on 12.01.2022.
//

import Foundation
import Moya

enum API {
    case getTopics
    case getCardSet(id: String)
}

extension API: TargetType {
    
    public var baseURL: URL {
        return URL(string: "https://api.active-study.boberneprotiv.com")!
    }
    
    public var path: String {
        switch self {
        case .getTopics:
            return "/education-materials/flash-cards"
        case .getCardSet(let id):
            return "/education-materials/flash-cards/\(id)"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        return.requestPlain
    }
    
    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
    
    public var headers: [String: String]? {
        return [
            "Content-Type": "application/json"
        ]
    }
}
