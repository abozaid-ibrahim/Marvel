//
//  HeroCollectionCell.swift
//  Marvel
//
//  Created by abuzeid on 22.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import UIKit

final class HeroCollectionCell: UICollectionViewCell {
    @IBOutlet private var heroImageView: UIImageView!
    @IBOutlet private var selectionBorderView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    private var imageLoader: Disposable?

    func setData(with hero: Hero) {
        imageLoader = heroImageView.setImage(with: hero.thumbnail.photo)
        titleLabel.text = hero.name
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        set(isSelected: false)
    }

    func set(isSelected: Bool) {
        selectionBorderView.backgroundColor = isSelected ? .purple : .blue
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoader?.dispose()
    }
}
