//
//  MovieDetailsController.swift
//  IMDB
//
//  Created by abuzeid on 14.08.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import UIKit

final class MovieDetailsController: UIViewController {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var overviewLabel: UILabel!
    @IBOutlet private var ratingBar: RatingBar!
    @IBOutlet private var releaseDate: UILabel!
    var movie: Movie!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = movie.originalTitle
        ratingBar.rating = movie.rating
        titleLabel.text = movie.title
        releaseDate.text = movie.releaseDate
        overviewLabel.text = movie.overview
        imageView.setImage(with: movie.posterPath ?? "", size: .original)
    }
}

extension Movie {
    var rating: CGFloat {
        return CGFloat(voteAverage / 2)
    }
}
