//
//  MoyaProvider + Request.swift
//  FlashCards
//
//  Created by Ivan Pohorielov on 12.01.2022.
//

import Foundation
import Moya
import Result

public extension MoyaProvider {
    
    @discardableResult
    func request<T: Codable>(_ target: Target, objectModel: T.Type, path: String? = nil, success: ((_ returnData: T) -> Void)?, failure: ((_ Error: MoyaError) -> Void)?) -> Cancellable? {
        
        return request(target, completion: {
            
            if let error = $0.error {
                failure?(error)
                return
            }
            
            do {
                guard let returnData = try $0.value?.mapObject(objectModel.self, path: path) else {
                    return
                }
                success?(returnData)
            } catch {
                failure?(MoyaError.jsonMapping($0.value!))
            }
        })
    }
    
    @discardableResult
    func request<T: Codable>(_ target: Target, arrayModel: T.Type, path: String? = nil, success: ((_ returnData: [T]) -> Void)?, failure: ((_ Error: MoyaError) -> Void)?) -> Cancellable? {
        
        return request(target, completion: {
            
            if let error = $0.error {
                
                failure?(error)
                return
            }
            
            do {
                
                guard let returnData = try $0.value?.mapArray(arrayModel.self, path: path) else {
                    return
                }
                success?(returnData)
            } catch {
                failure?(MoyaError.jsonMapping($0.value!))
            }
        })
    }
    
}

public extension Response {
    
    func mapObject<T: Codable>(_ type: T.Type, path: String? = nil) throws -> T {
        
        do {
            return try JSONDecoder().decode(T.self, from: try getJsonData(path))
        } catch {
            print(String(describing: error))
            throw MoyaError.jsonMapping(self)
        }
    }
    
    func mapArray<T: Codable>(_ type: T.Type, path: String? = nil) throws -> [T] {
        
        do {
            return try JSONDecoder().decode([T].self, from: try getJsonData(path))
        } catch {
            print(String(describing: error))
            throw MoyaError.jsonMapping(self)
        }
    }
    
    private func getJsonData(_ path: String? = nil) throws -> Data {
        
        do {
            var jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            if let path = path {
                guard let specificObject = jsonObject.value(forKeyPath: path) else {
                    throw MoyaError.jsonMapping(self)
                }
                jsonObject = specificObject as AnyObject
            }
            
            return try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        } catch {
            throw MoyaError.jsonMapping(self)
        }
    }
    
}

extension MoyaError {
    
    var description: String {
        
        if let errorResponse = try? response?.mapJSON() as? NSDictionary {
            if let errors = errorResponse.value(forKey: "errors") as? NSDictionary {
                if let allValues = errors.allValues as? [[String]] {
                    var errorStrings: [String] = []
                    allValues.forEach({ (errorDescriptions) in
                        errorStrings.append(contentsOf: errorDescriptions)
                    })
                    return errorStrings.joined(separator: "\n")
                }
            } else if let error = errorResponse.value(forKey: "errors") as? String {
                return error
            } else if let error = errorResponse.value(forKey: "error") as? String {
                return error
            } else if let error = errorResponse.value(forKey: "message") as? String {
                return error
            }
        } else if let errorDescription = self.errorDescription {
            return errorDescription
        }
        
        return "An unknown error has occurred"//.localize()
    }
    
    var httpCode: Int? {
        return self.response?.statusCode
    }
    
}

