//
//  RecipeTableCell.swift
//  HelloFreshDevTest
//
//  Created by abuzeid on 31.07.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import UIKit
typealias ButtonAction = () -> Void

final class RecipeTableCell: UITableViewCell {
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var headlineLabel: UILabel!
    @IBOutlet private var ratingBar: RatingBar!
    @IBOutlet private var favouriteButton: UIButton!
    private var favouriteChanged: ButtonAction?
    private var ratingChanged: RatingValueChanged?
    
    func setData(of recipe: Recipe, showDetails: Bool = false, onFavourite: @escaping ButtonAction, rating: @escaping RatingValueChanged) {
        favouriteChanged = onFavourite
        ratingChanged = rating
        ratingBar.rating = CGFloat(recipe.averageRating)
        nameLabel.text = showDetails ? recipe.headline : recipe.name
        headlineLabel.text = showDetails ? recipe.recipesListResponseDescription : recipe.headline
        let imageName = recipe.isFavourite ? "heart" : "heart_off"
        favouriteButton.setImage(UIImage(named: imageName), for: .normal)
        ratingBar.ratingValueChanged = rating
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        favouriteChanged = nil
        ratingChanged = nil
    }

    @IBAction func favouriteChanged(_ sender: Any) {
        favouriteChanged?()
    }
}
