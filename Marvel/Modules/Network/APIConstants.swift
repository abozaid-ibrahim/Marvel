//
//  APIConstants.swift
//  Marvel
//
//  Created by abuzeid on 22.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//
import CryptoKit
import Foundation
struct APIConstants {
    static let baseURL = "http://gateway.marvel.com/"
    static let imageBaseUrl = "https://image.tmdb.org/t/p/"
    static let apiToken = "651883284af1c1f6b2e73a9c8df65973"
    static let publicKey = "651883284af1c1f6b2e73a9c8df65973"
    static let privateKey = "e76612a1072d481cd5f5b583bd30f70e3e9c4bd7"

    static var api: (ts: String, hash: String) {
        let date = String(Date().timeIntervalSince1970)
        let hash = MD5(string: date + privateKey + publicKey)
        return (ts: date, hash: hash)
    }

    private static func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}
