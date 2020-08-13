//
//  Albums.swift
//  IMDB
//
//  Created by abuzeid on 13.08.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

struct AlbumsResponse: Codable {
    let data: DataClass
}

struct DataClass: Codable {
    let sessions: [Session]
}

struct Session: Codable {
    let name: String
    let listenerCount: Int
    let genres: [String]
    let currentTrack: CurrentTrack

    enum CodingKeys: String, CodingKey {
        case name
        case listenerCount = "listener_count"
        case genres
        case currentTrack = "current_track"
    }
}

struct CurrentTrack: Codable {
    let title: String
    let artworkURL: String

    enum CodingKeys: String, CodingKey {
        case title
        case artworkURL = "artwork_url"
    }
}
