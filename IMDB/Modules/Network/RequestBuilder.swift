//
//  APIClient.swift
//  IMDB
//
//  Created by abuzeid on 13.08.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//
import Foundation

public protocol RequestBuilder {
    var baseURL: URL { get }

    var path: String { get }

    var method: HttpMethod { get }

    var request: URLRequest { get }

    var headers: [String: String]? { get }
}

public enum HttpMethod: String {
    case get, post
}

struct APIConstants {
    static let baseURL = "http://www.mocky.io/v2/"
    static let apiToken = "c6a773bedb900d001f886b2cdd0ae471"
    static let accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjNmE3NzNiZWRiOTAwZDAwMWY4ODZiMmNkZDBhZTQ3MSIsInN1YiI6IjVmMzViNjQ0OTM4MjhlMDAzNTNlYzE5YSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.3kh4i62KcuCHfOt91TLrl5Hkx8VtvEPF6AMR68SVrkU"
}
