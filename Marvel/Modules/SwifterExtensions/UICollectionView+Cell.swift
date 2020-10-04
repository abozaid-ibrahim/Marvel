//
//  UICollectionView+Cell.swift
//  Marvel
//
//  Created by abuzeid on 22.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionView {
    enum CollSize {
        case with(width: CGFloat, height: CGFloat)
    }

    /// WARNING: you must set the reuse identifier as same as the nib file name.
    func register<T: UICollectionViewCell>(_: T.Type) {
        let nib = UINib(nibName: T.identifier, bundle: Bundle(for: T.self))
        register(nib, forCellWithReuseIdentifier: T.identifier)
    }

    func updateFooterHeight(height: CGFloat = 50) {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.footerReferenceSize = CGSize(width: layout.footerReferenceSize.width, height: height)
        setCollectionViewLayout(layout, animated: false)
    }
}
