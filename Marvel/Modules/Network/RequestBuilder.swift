//
//  APIClient.swift
//  Marvel
//
//  Created by abuzeid on 22.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//
import Foundation

public protocol RequestBuilder {
    var baseURL: URL { get }

    var path: String { get }

    var method: HttpMethod { get }

    var request: URLRequest { get }

    var parameters: [String: Any] { get }
}

public enum HttpMethod: String {
    case get, post
}
