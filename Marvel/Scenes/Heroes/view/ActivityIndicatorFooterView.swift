//
//  ActivityIndicatorFooterView.swift
//  Marvel
//
//  Created by abuzeid on 22.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import UIKit

final class ActivityIndicatorFooterView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    static var id: String {
        return String(describing: self)
    }

    private func setup() {
        let activityView: UIActivityIndicatorView
        if #available(iOS 13, *) {
            activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        } else {
            activityView = UIActivityIndicatorView(style: .gray)
        }
        activityView.hidesWhenStopped = true
        activityView.startAnimating()
        addSubview(activityView)
        activityView.center = center
    }
}
