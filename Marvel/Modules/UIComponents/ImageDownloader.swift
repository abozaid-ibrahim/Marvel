//
//  ImageDownloader.swift
//  Marvel
//
//  Created by abuzeid on 23.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit
typealias DownloadImageCompletion = (UIImage?) -> Void
protocol ImageDownloaderType {
    func downloadImageWith(url: URL, completion: DownloadImageCompletion?) -> Disposable?
    func cached(url: String) -> UIImage?
}

public protocol Disposable {
    func dispose()
}

extension URLSessionDataTask: Disposable {
    public func dispose() {
        cancel()
    }
}

public final class ImageDownloader: ImageDownloaderType {
    func downloadImageWith(url: URL, completion: DownloadImageCompletion? = nil) -> Disposable? {
        if let data = cached(url: url.absoluteString) {
            completion?(data)
            return nil
        }
        guard Reachability.shared.hasInternet() else { return nil }
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                let image = UIImage(data: data) else {
                completion?(nil)
                return
            }
            let obj = Image(image: data, url: url.absoluteString)
            CoreDataIO.shared.save(data: [obj], entity: .images)
            completion?(image)
        }
        dataTask.resume()
        return dataTask
    }
}

// MARK: Caching

extension ImageDownloader {
    func cached(url: String) -> UIImage? {
        guard let object = CoreDataIO.shared.load(offset: 0, entity: .images, predicate: .image(of: url)).first,
            let data = object.value(forKey: "image") as? Data,
            let date = object.value(forKey: "date") as? Date,
            let validDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { return nil }
        if validDate < Date() {
            CoreDataIO.shared.clearCache(for: .images, where: .image(of: url))
            return nil
        }
        return UIImage(data: data)
    }
}

extension UIImageView {
    @discardableResult
    func setImage(with path: String) -> Disposable? {
        guard let url = URL(string: path) else { return nil }
        return ImageDownloader().downloadImageWith(url: url, completion: { [weak self] image in
            DispatchQueue.main.async {
                self?.image = image
            }
        })
    }
}
