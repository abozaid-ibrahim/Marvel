//
//  HeroesResponse.swift
//  Marvel
//
//  Created by abuzeid on 22.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.

import Foundation

struct HeroesResponse: Codable {
    let data: DataClass?
}

struct DataClass: Codable {
    let offset, limit, total, count: Int?
    let results: [Hero]?
}

struct Hero: Codable {
    let id: Int
    let name: String?
    let thumbnail: Thumbnail?
}

extension Optional where Wrapped == Thumbnail {
    var photo: String {
        guard let thumb = self,
            let type = thumb.thumbnailExtension,
            let path = thumb.path else { return "" }
        return path + "." + type
    }
}

struct Thumbnail: Codable {
    let path: String?
    let thumbnailExtension: String?

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

extension Thumbnail {
    static func instance(from photo: String) -> Thumbnail? {
        let parts = photo.split(separator: ".").map { String($0) }.last
        var path = photo
        guard let dotIndex = parts?.count else { return nil }
        path.removeLast(dotIndex + 1)

        return Thumbnail(path: path, thumbnailExtension: parts ?? "")
    }
}

extension Hero: CoreDataCachable {
    var keyValued: [String: Any] {
        return ["id": id,
                "name": name ?? "",
                "thumbnail": thumbnail.photo]
    }
}
