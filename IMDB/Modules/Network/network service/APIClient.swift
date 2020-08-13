//
//  APIClient.swift
//  IMDB
//
//  Created by abuzeid on 13.08.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//
import Foundation
import RxSwift
import RxCocoa

protocol ApiClient {
    func getData<T: Decodable>(of request: RequestBuilder) -> Observable<T?>
    func cancel()
}

/// api handler, wrapper for the Url session
final class HTTPClient: ApiClient {
    func cancel() {
        //TODO:
    }
    
    private let disposeBag = DisposeBag()
    func getData<T: Decodable>(of request: RequestBuilder) -> Observable<T?> {
        return excute(request).compactMap { $0?.toModel() }
    }

    /// fire the http request and return observable of the data or emit an error
    /// - Parameter request: the req uest that have all the details that need to call the remote api
    private func excute(_ request: RequestBuilder) -> Observable<Data?> {
        return Observable<Data?>.create { (observer) -> RxSwift.Disposable in
            let task = URLSession.shared.dataTask(with: request.request) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                    (200 ... 299).contains(httpResponse.statusCode) else {
                    observer.onError(NetworkFailure.generalFailure)
                    return
                }
                observer.onNext(data)
            }
            task.resume()
            return Disposables.create()
        }
        .share(replay: 0, scope: .forever)
    }
}
