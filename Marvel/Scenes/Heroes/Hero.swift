//
//  HeroesResponse.swift
//  Marvel
//
//  Created by abuzeid on 22.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.

import Foundation

struct HeroesResponse: Codable {
    let code: Int?
    let status, copyright, attributionText, attributionHTML: String?
    let etag: String?
    let data: DataClass?
}

// MARK: - DataClass

struct DataClass: Codable {
    let offset, limit, total, count: Int?
    let results: [Hero]?
}

// MARK: - Result

struct Hero: Codable {
    let id: Int
    let name, resultDescription: String?
    let thumbnail: Thumbnail?

    let resourceURI: String?
    let comics: Comics?

    enum CodingKeys: String, CodingKey {
        case id, name
        case resultDescription = "description"
        case thumbnail, resourceURI, comics
    }
}

extension Optional where Wrapped == Thumbnail {
    var photo: String {
        guard let thumb = self,
            let type = thumb.thumbnailExtension?.rawValue,
            let path = thumb.path else { return "" }
        return path + "." + type
    }
}

// MARK: - Comics

struct Comics: Codable {
    let available: Int?
    let collectionURI: String?
    let items: [ComicsItem]?
    let returned: Int?
}

// MARK: - ComicsItem

struct ComicsItem: Codable {
    let resourceURI: String?
    let name: String?
}

// MARK: - Stories

struct Thumbnail: Codable {
    let path: String?
    let thumbnailExtension: Extension?

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

enum Extension: String, Codable {
    case gif
    case jpg
}
