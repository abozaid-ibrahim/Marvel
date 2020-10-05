//
//  HeroFeedTableCell.swift
//  Marvel
//
//  Created by abuzeid on 23.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import UIKit

final class HeroFeedTableCell: UITableViewCell {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var comicImageView: UIImageView!
    @IBOutlet private var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        comicImageView.image = nil
    }

    func setData(of comic: Feed) {
        titleLabel.text = comic.title
        dateLabel.text = comic.modified
        comicImageView.setImage(with: comic.thumbnail.photo)
    }
}
