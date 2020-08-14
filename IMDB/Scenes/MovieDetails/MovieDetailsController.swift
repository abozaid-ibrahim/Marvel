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
    let movie: Movie
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: String(describing: MovieDetailsController.self),
                   bundle: Bundle(for: MovieDetailsController.self))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }

    private func setData() {
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
