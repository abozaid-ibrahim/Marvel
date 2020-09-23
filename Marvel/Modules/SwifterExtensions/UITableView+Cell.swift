//
//  UITableView+Cell.swift
//  Marvel
//
//  Created by abuzeid on 22.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import UIKit

extension UITableView {
    /// WARNING: you must set the reuse identifier as same as the nib file name.
    func register<T: UITableViewCell>(_: T.Type) {
        let nib = UINib(nibName: T.identifier, bundle: Bundle(for: T.self))
        register(nib, forCellReuseIdentifier: T.identifier)
    }
}

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

