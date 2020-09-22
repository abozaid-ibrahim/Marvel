//
//  Recipe.swift
//  HelloFreshDevTest
//
//  Created by abuzeid on 31.07.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

struct Recipe: Codable {
    let id, name, headline, recipesListResponseDescription: String
    let difficulty: Int
    let prepTime: String
    let link: String
    let imageLink: String
    let nutrition: [Nutrition]
    let ingredients: [Ingredient]
    var averageRating: Float
    let ratingsCount: Int
    let country: String?
    var isFavourite: Bool = false
    enum CodingKeys: String, CodingKey {
        case id, name, headline
        case recipesListResponseDescription = "description"
        case difficulty, prepTime, link, imageLink, nutrition, ingredients, averageRating, ratingsCount, country
    }
}

extension Recipe {
    mutating func toggleFavourite() {
        isFavourite.toggle()
    }

    mutating func setRate(rate: Float) {
        averageRating = rate
    }
}

struct Ingredient: Codable {
    let id, type, name: String
    let imageLink: String
}

struct Nutrition: Codable {
    let id: String?
    let name: String
    let amount: Int
    let unit: Unit
    let type: String?
}

enum Unit: String, Codable {
    case g
    case kJ
    case kcal
    case mg
}
