//
//  FeedResponse.swift
//  Marvel
//
//  Created by abuzeid on 23.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.

import Foundation

struct FeedResponse: Codable {
    let code: Int?
    let status, copyright, attributionText, attributionHTML: String?
    let etag: String?
    let data: FeedDataClass?
}

// MARK: - DataClass

struct FeedDataClass: Codable {
    let offset, limit, total, count: Int?
    let results: [FeedResult]?
}

// MARK: - Result

struct FeedResult: Codable {
    let id, digitalID: Int
    let title: String?
    let issueNumber: Int?
    let modified, isbn, upc, diamondCode: String?
    let pageCount: Int?
    let thumbnail: Thumbnail?
    let images: [Thumbnail]?

    enum CodingKeys: String, CodingKey {
        case id
        case digitalID = "digitalId"
        case title, issueNumber
        case modified, isbn, upc, diamondCode, pageCount, thumbnail, images
    }
}

// MARK: - DateElement

struct DateElement: Codable {
    let type: DateType?
    let date: String?
}

enum DateType: String, Codable {
    case digitalPurchaseDate
    case focDate
    case onsaleDate
    case unlimitedDate
}

// MARK: - Thumbnail

// MARK: - Price

struct Price: Codable {
    let type: PriceType?
    let price: Double?
}

enum PriceType: String, Codable {
    case digitalPurchasePrice
    case printPrice
}

// MARK: - TextObject

struct TextObject: Codable {
    let type, language, text: String?
}

// MARK: - URLElement

enum VariantDescription: String, Codable {
    case empty = ""
    case spotlightVariant = "SPOTLIGHT VARIANT"
    case zombieVariant = "ZOMBIE VARIANT"
}

// MARK: - Encode/decode helpers
