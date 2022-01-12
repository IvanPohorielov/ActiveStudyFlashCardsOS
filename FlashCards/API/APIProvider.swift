//
//  APIProvider.swift
//  FlashCards
//
//  Created by Ivan Pohorielov on 12.01.2022.
//

import Foundation
import Moya
import Result

class APIProvider {
    
    static let shared = APIProvider()
    
    let provider = MoyaProvider<API>()
    
    func getTopics(closure: @escaping ([TopicDataModel]?) -> ()) {
        provider.request(.getTopics, arrayModel: TopicDataModel.self, success: { (topics) in
            
            print("Success getTopics!")
            closure(topics)
            
        }) { (error) in
            
            print("Error getTopics!", error)
            closure(nil)
            
        }
    }
    
    func getCardSet(with id: String,closure: @escaping (CardSetDataModel?) -> ()) {
        provider.request(.getCardSet(id: id), objectModel: CardSetDataModel.self, success: { (cardSet) in
            
            print("Success getCardSet!")
            closure(cardSet)
            
        }) { (error) in
            
            print("Error getCardSet!", error)
            closure(nil)
            
        }
    }
    
    
}
