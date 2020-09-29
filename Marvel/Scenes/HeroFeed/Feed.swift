//
//  FeedResponse.swift
//  Marvel
//
//  Created by abuzeid on 23.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.

import Foundation

struct FeedJsonResponse: Codable {
    let data: FeedDataClass?
}

struct FeedDataClass: Codable {
    let offset, limit, total, count: Int?
    let results: [Feed]?
}

struct Feed: Codable {
    let id: Int
    let title: String?
    let modified: String?
    let thumbnail: Thumbnail?
}

extension Feed: CoreDataCachable {
    var keyValued: [String: Any] {
        return ["id": id,
                "title": title ?? "",
                "modified": modified ?? "",
                "thumbnail": thumbnail.photo,
        ]
    }
}
