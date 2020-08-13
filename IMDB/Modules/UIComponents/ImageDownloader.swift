//
//  ImageDownloader.swift
//  HelloFreshDevTest
//
//  Created by abuzeid on 02.08.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit
typealias DownloadImageCompletion = (UIImage?) -> Void
protocol ImageDownloaderType {
    func downloadImageWith(url: URL, completion: DownloadImageCompletion?) -> Disposable
}

public protocol Disposable {
    func dispose()
}

extension URLSessionDataTask: Disposable {
    public func dispose() {
        cancel()
    }
}

// TODO: Add Image Local Caching
public final class ImageDownloader: ImageDownloaderType {
    func downloadImageWith(url: URL, completion: DownloadImageCompletion? = nil) -> Disposable {
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                let image = UIImage(data: data) else {
                completion?(nil)
                return
            }
            completion?(image)
        }
        dataTask.resume()
        return dataTask
    }
}

extension UIImageView {
    enum Size: String {
        case thumbnail = "w500"
        case original = "original"
    }

    func setImage(with path: String, size: Size = .original) -> Disposable? {
        guard let url = URL(string: "\(APIConstants.imageBaseUrl)\(size)\(path)") else { return nil }
        return ImageDownloader().downloadImageWith(url: url, completion: { [weak self] image in
            DispatchQueue.main.async {
                self?.image = image
            }
        })
    }
}
