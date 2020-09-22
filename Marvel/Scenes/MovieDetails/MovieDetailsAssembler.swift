//
//  ModuleAssembler.swift
//  Marvel
//
//  Created by abuzeid on 22.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit

extension Destination {
    func getMovieDetailsController(movie: Movie) -> UIViewController {
        return MovieDetailsController(movie: movie)
    }
}
