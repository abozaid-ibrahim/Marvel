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
    func cachImage(url: String, image: Data)
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
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data,
                let image = UIImage(data: data) else {
                completion?(nil)
                return
            }
            self?.cachImage(url: url.absoluteString, image: data)
            completion?(image)
        }
        dataTask.resume()
        return dataTask
    }
}

// MARK: Caching

extension ImageDownloader {
    func cachImage(url: String, image: Data) {
        let obj = Image(image: image, url: url)
        CoreDataHelper.shared.save(data: [obj], entity: .images)
    }

    func cached(url: String) -> UIImage? {
        guard let object = CoreDataHelper.shared.load(offset: 0, entity: .images, predicate: .image(of: url)).first,
            let data = object.value(forKey: "image") as? Data,
            let date = object.value(forKey: "date") as? Date,
            let validDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { return nil }
        if validDate < Date() {
            CoreDataHelper.shared.clearCache(for: .images, where: .image(of: url))
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
