//
//  FeedContainerController.swift
//  Marvel
//
//  Created by abuzeid on 22.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import RxSwift
import UIKit

final class FeedContainerController: UIViewController {
    @IBOutlet private var heroesListContainer: UIView!
    @IBOutlet private var heroFeedContainer: UIView!
    @IBOutlet private var heroesListHeight: NSLayoutConstraint!
    
    // TODO: optimize data flow between feed, and heroes
    lazy var heroes: HeroesController = {
        let viewModel = HeroesViewModel()
        let controller = HeroesController(viewModel: viewModel,height: heroesListHeight.constant)
        viewModel.selectHero
            .bind(to: self.viewModel.selectHeroById)
            .disposed(by: controller.disposeBag)
        return controller
    }()

    private let viewModel = HeroFeedViewModel()
    lazy var feed: HeroFeedTableController = {
        let controller = HeroFeedTableController(viewModel: viewModel)
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Str.discover
        addHeroes()
        addFeed()
    }

    private func addHeroes() {
        addChild(heroes)
        heroesListContainer.addSubview(heroes.view)
        heroes.view.setConstrainsEqualToParentEdges()
    }

    private func addFeed() {
        addChild(feed)
        heroFeedContainer.addSubview(feed.view)
        feed.view.setConstrainsEqualToParentEdges()
    }
}
