//
//  RecipesListAssembler.swift
//  Marvel
//
//  Created by abuzeid on 23.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit

extension Destination {
    func getHeroFeedTableController() -> UIViewController {
        let viewModel = HeroFeedViewModel()
        return HeroFeedTableController(viewModel: viewModel)
    }
}
