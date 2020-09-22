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
    enum CollectionWidth {
        case twoColumn
    }

    /// TIP: you must set the reuse identifier as same as the nib file name.
    func register<T: UICollectionViewCell>(_: T.Type) {
        let nib = UINib(nibName: T.identifier, bundle: Bundle(for: T.self))
        register(nib, forCellWithReuseIdentifier: T.identifier)
    }

    func setCell(type: CollectionWidth, padding: CGFloat = CGFloat(16)) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        if case .twoColumn = type {
            let space = (self.bounds.width - (3 * padding)) / 2
            let cellSize = CGSize(width: space, height: space)
            layout.itemSize = cellSize
            layout.sectionInset = .init(top: padding, left: padding, bottom: padding, right: padding)
            layout.minimumInteritemSpacing = padding
            layout.minimumLineSpacing = padding
            layout.footerReferenceSize = CGSize(width: space * 2, height: space / 2)
            setCollectionViewLayout(layout, animated: true)
        }
    }

    func updateFooterHeight(height: CGFloat = 50) {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.footerReferenceSize = CGSize(width: layout.footerReferenceSize.width, height: height)
        setCollectionViewLayout(layout, animated: false)
    }
}
