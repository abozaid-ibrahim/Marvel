//
//  ImageDownloader.swift
//  HelloFreshDevTest
//
//  Created by abuzeid on 22.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit
typealias DownloadImageCompletion = (UIImage?) -> Void
protocol ImageDownloaderType {
    func downloadImageWith(url: URL, completion: DownloadImageCompletion?) -> Disposable?
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
        //TODO: add date to image to 24 hours
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

    private func cachImage(url: String, image: Data) {
        CoreDataHelper.shared.saveImage(url: url, data: image)
    }

    private func cached(url: String) -> UIImage? {
        guard let data = CoreDataHelper.shared.getImage(url: url) else { return nil }
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
