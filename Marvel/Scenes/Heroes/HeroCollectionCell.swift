//
//  HeroCollectionCell.swift
//  Marvel
//
//  Created by abuzeid on 22.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import UIKit

final class HeroCollectionCell: UICollectionViewCell {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    private var imageLoader: Disposable?

    func setData(with hero: Hero) {
        imageLoader = imageView.setImage(with: hero.thumbnail.photo)
        titleLabel.text = hero.name
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.cornerRadius = 12
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoader?.dispose()
    }
}
