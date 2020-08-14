//
//  ModuleAssembler.swift
//  IMDB
//
//  Created by abuzeid on 13.08.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit

extension Destination {
    func getMovieDetailsController(movie: Movie) -> UIViewController {
        let controller = MovieDetailsController()
        controller.movie = movie
        return controller
    }
}
