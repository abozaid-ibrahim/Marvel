//
//  ModuleAssembler.swift
//  Marvel
//
//  Created by abuzeid on 22.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit

enum Destination {
    case feedPage
    case heroesList
    case heroFeed(Movie)
    var controller: UIViewController {
        switch self {
        case .feedPage:
            return FeedContainerController()
        case .heroesList:
            return getMoviesController()
        case .heroFeed:
            return getMoviesController()
        }
    }
}

extension Destination {
    func getMoviesController() -> UIViewController {
        return HeroesController(viewModel: HeroesViewModel())
    }
}
