//
//  AlbumCollectionCell.swift
//  IMDB
//
//  Created by abuzeid on 13.08.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import UIKit

final class AlbumCollectionCell: UICollectionViewCell {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var genresLabel: UILabel!
    private var imageLoader: Disposable?
    
    func setData(with session: Session) {
        imageLoader = imageView.setImage(with: session.currentTrack.artworkURL)
        nameLabel.text = session.name
        titleLabel.text = session.currentTrack.title
        genresLabel.text = String(session.genres.count)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.cornerRadius = 12
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoader = nil
    }
}
