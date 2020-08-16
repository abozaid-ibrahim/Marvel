//
//  RatingBar.swift
//  IMDB
//
//  Created by abuzeid on 13.08.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import UIKit
typealias RatingValueChanged = (Float) -> Void

final class RatingBar: UIView {
    var ratingValueChanged: RatingValueChanged?
    @IBInspectable var rating: CGFloat = 0 {
        didSet {
            if 0 >= rating { rating = 0 }
            else if ratingMax <= rating { rating = ratingMax }
            self.setNeedsLayout()
        }
    }

    @IBInspectable var ratingMax: CGFloat = 5
    @IBInspectable var numStars: Int = 5
    @IBInspectable var canAnimation: Bool = true
    @IBInspectable var animationTimeInterval: TimeInterval = 0.2
    @IBInspectable var isIndicator: Bool = true
    @IBInspectable var imageLight: UIImage = UIImage(named: "star_on")!
    @IBInspectable var imageDark: UIImage = UIImage(named: "star_off")!

    private var foregroundRatingView: UIView!
    private var backgroundRatingView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        buildView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        animateChange()
    }

    @objc func tapRateView(sender: UITapGestureRecognizer) {
        if isIndicator { return }
        let tapPoint = sender.location(in: self)
        let offset = tapPoint.x
        let realRatingScore = offset / (bounds.size.width / ratingMax)
        rating = round(realRatingScore)
        ratingValueChanged?(Float(rating))
    }
}

// MARK: setup

private extension RatingBar {
    func buildView() {
        subviews.forEach { $0.removeFromSuperview() }
        backgroundRatingView = createRatingView(image: imageDark)
        foregroundRatingView = createRatingView(image: imageLight)
        animationRatingChange()
        addSubview(backgroundRatingView)
        addSubview(foregroundRatingView)
        backgroundRatingView.setConstrainsEqualToParentEdges()
        foregroundRatingView.setConstrainsEqualToParentEdges()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapRateView(sender:)))
        tapGesture.numberOfTapsRequired = 1
        addGestureRecognizer(tapGesture)
    }

    func animateChange() {
        let animationTimeInterval = canAnimation ? self.animationTimeInterval : 0
        UIView.animate(withDuration: animationTimeInterval, animations: { self.animationRatingChange() })
    }

    func animationRatingChange() {
        let realRatingScore = rating / ratingMax
        foregroundRatingView.frame = CGRect(x: 0, y: 0, width: bounds.size.width * realRatingScore, height: bounds.size.height)
    }

    func createRatingView(image: UIImage) -> UIView {
        let view = UIView(frame: bounds)
        view.clipsToBounds = true
        view.backgroundColor = UIColor.clear
        let container = newStackView
        view.addSubview(container)
        container.setConstrainsEqualToParentEdges()
        for _ in 0 ..< numStars {
            let imageView = UIImageView(image: image)
            imageView.setConstrains(width: bounds.size.width / CGFloat(numStars), height: bounds.size.height)
            imageView.contentMode = UIView.ContentMode.scaleAspectFit
            container.addArrangedSubview(imageView)
        }
        return view
    }

    var newStackView: UIStackView {
        let container = UIStackView()
        container.alignment = .fill
        container.axis = .horizontal
        container.distribution = .fillEqually
        container.clipsToBounds = true
        container.spacing = 4
        return container
    }
}
