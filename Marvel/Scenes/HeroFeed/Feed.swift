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
    let id : Int
    let title: String?
    let modified: String?
    let thumbnail: Thumbnail?
    let images: [Thumbnail]?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case modified, thumbnail, images
    }
}


