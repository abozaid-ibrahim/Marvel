//
//  ModuleAssembler.swift
//  IMDB
//
//  Created by abuzeid on 13.08.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit

enum Destination {
    case movies
    var controller: UIViewController {
        switch self {
        case .movies:
            return getMoviesController()
        }
    }
}

extension Destination {
    func getMoviesController() -> UIViewController {
        return MoviesController(viewModel: MoviesViewModel())
    }
}
