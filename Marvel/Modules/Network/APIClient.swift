//
//  APIClient.swift
//  Marvel
//
//  Created by abuzeid on 22.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//
import Foundation

protocol ApiClient {
    func getData(of request: RequestBuilder, completion: @escaping (Result<Data, Error>) -> Void)
    func cancel()
}

final class HTTPClient: ApiClient {
    func getData(of request: RequestBuilder, completion: @escaping (Result<Data, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: request.request) { data, response, error in
            log(error, level: .error)
            if let error = error {
                completion(.failure(.apiError(error.localizedDescription)))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200 ... 299).contains(httpResponse.statusCode) else {
                log("Response is not valid", level: .error)
                completion(.failure(.outOfRange))
                return
            }
            guard let data = data else {
                completion(.failure(.dataIsNil))
                return
            }
            completion(.success(data))
        }

        task.resume()
    }

    func cancel() {
        // TODO:
    }
}
