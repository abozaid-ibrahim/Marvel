//
//  RecipesTableController.swift
//  HelloFreshDevTest
//
//  Created by abuzeid on 31.07.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import UIKit

final class RecipesTableController: UITableViewController {
    private let viewModel: RecipesListViewModelType
    private var recipesList: [Recipe] { return viewModel.recipesList }

    init(viewModel: RecipesListViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        title = Str.appName
        tableView.register(UINib(nibName: RecipeTableCell.identifier, bundle: nil), forCellReuseIdentifier: RecipeTableCell.identifier)
        tableView.rowHeight = 90
        viewModel.reloadField.subscribe { [weak self] row in
            if case let TableReload.row(position) = row {
                self?.tableView.reloadRows(at: [IndexPath(row: position, section: 0)], with: .none)
            } else if case TableReload.all = row {
                self?.tableView.reloadData()
            }
        }
        viewModel.loadRecipes()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecipeTableCell.identifier, for: indexPath) as! RecipeTableCell
        cell.setData(of: recipesList[indexPath.row],
                     onFavourite: { [weak self] in self?.viewModel.toggleFavourite(row: indexPath.row) },
                     rating: { [weak self] value in self?.viewModel.setRating(value, for: indexPath.row) })
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppNavigator.shared.push(.recipeDetails(recipesList[indexPath.row]))
    }
}
