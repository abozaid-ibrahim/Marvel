//
//  UISearchBar+ActivityIndicator.swift
//  IMDB
//
//  Created by abuzeid on 13.08.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit

extension UISearchBar {
    public var textField: UITextField? {
        if #available(iOS 13.0, *) {
            return self.searchTextField
        } else {
            let subViews = subviews.flatMap { $0.subviews }
            guard let textField = (subViews.filter { $0 is UITextField }).first as? UITextField else {
                return nil
            }
            return textField
        }
    }

    public var defaultLeftView: UIView? {
        return UISearchBar().textField?.leftView
    }

    public var activityIndicator: UIActivityIndicatorView? {
        return textField?.leftView as? UIActivityIndicatorView
    }

    var isLoading: Bool {
        get {
            return activityIndicator != nil
        } set {
            if newValue {
                guard activityIndicator == nil else { return }
                let activityView: UIActivityIndicatorView
                if #available(iOS 13, *) {
                    activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
                } else {
                    activityView = UIActivityIndicatorView(style: .gray)
                }
                activityView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                activityView.startAnimating()
                textField?.leftView = activityView
            } else {
                activityIndicator?.removeFromSuperview()
                textField?.leftView = defaultLeftView
            }
        }
    }
}
