//
//  RecipesViewModel.swift
//  HelloFreshDevTest
//
//  Created by abuzeid on 31.07.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
protocol RecipeOperations {
    var reloadField: Observable<TableReload> { get }
    func toggleFavourite(row: Int)
    func setRating(_ value: Float, for row: Int)
}

protocol RecipesListViewModelType: RecipeOperations {
    var recipesList: [Recipe] { get }
    func loadRecipes()
}

enum TableReload: Equatable {
    case all
    case row(Int)
    case none
}

final class RecipesListViewModel: RecipesListViewModelType {
    private(set) var recipesList: [Recipe] = []
    let reloadField: Observable<TableReload> = .init(.none)

    func loadRecipes() {
        guard let repos = try? Bundle.main.decode([Recipe].self, from: "RecipesList.json") else { return }
        recipesList = repos
        reloadField.next(.all)
    }

    func toggleFavourite(row: Int) {
        recipesList[row].toggleFavourite()
        reloadField.next(.row(row))
    }

    func setRating(_ value: Float, for row: Int) {
        recipesList[row].setRate(rate: value)
        reloadField.next(.row(row))
    }
}
