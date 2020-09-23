//
//  HeroFeedTableCell.swift
//  Marvel
//
//  Created by abuzeid on 23.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import UIKit

final class HeroFeedTableCell: UITableViewCell {
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var comicImageView: UIImageView!
    @IBOutlet private var headlineLabel: UILabel!
    @IBOutlet private var ratingBar: RatingBar!
    @IBOutlet private var favouriteButton: UIButton!
    private var ratingChanged: RatingValueChanged?

    func setData(of comic: FeedResult) {
//            favouriteChanged = onFavourite
//            ratingChanged = rating
//            ratingBar.rating = CGFloat(recipe.averageRating)
//            nameLabel.text = showDetails ? recipe.headline : recipe.name
//            headlineLabel.text = showDetails ? recipe.recipesListResponseDescription : recipe.headline
//            let imageName = recipe.isFavourite ? "heart" : "heart_off"
//            favouriteButton.setImage(UIImage(named: imageName), for: .normal)
//            ratingBar.ratingValueChanged = rating
        comicImageView.setImage(with: comic.thumbnail.photo)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        ratingChanged = nil
    }
}
