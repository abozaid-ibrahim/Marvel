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
    case heroFeed(Hero)
    var controller: UIViewController {
        switch self {
        case .feedPage:
            return FeedContainerController()
        case .heroesList:
            return getHerosController()
        case .heroFeed:
            return getHerosController()
        }
    }
}

extension Destination {
    func getHerosController() -> UIViewController {
        return HeroesController(viewModel: HeroesViewModel())
    }
}
