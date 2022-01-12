//
//  CardSetDataModel.swift
//  FlashCards
//
//  Created by Ivan Pohorielov on 12.01.2022.
//

import Foundation

struct CardSetDataModel: Codable {
    let id: String
    let title: String
    let cards: [CardDataModel]
}

struct CardDataModel: Codable {
    let id: String
    let term: String
    let definition: String
    let clues: [ClueDataModel]
}

struct ClueDataModel: Codable {
    let text: String
}
