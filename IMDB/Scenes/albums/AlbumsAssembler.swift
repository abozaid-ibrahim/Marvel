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
    case albums
    var controller: UIViewController {
        switch self {
        case .albums:
            return getAlbumsController()
        }
    }
}

extension Destination {
    func getAlbumsController() -> UIViewController {
        return AlbumsController(viewModel: AlbumsViewModel())
    }
}
