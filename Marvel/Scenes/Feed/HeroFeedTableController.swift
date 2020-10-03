//
//  RecipesTableController.swift
//  HelloFreshDevTest
//
//  Created by abuzeid on 31.07.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class HeroFeedTableController: UITableViewController {
    private let viewModel: HeroFeedViewModelType
    private var comicsList: [Feed] { viewModel.dataList }
    private let disposeBag = DisposeBag()
    private var last = CGFloat(0)

    init(viewModel: HeroFeedViewModelType) {
        self.viewModel = viewModel
        super.init(style: .grouped)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    // TODO: optimize data flow between feed, and heroes
    lazy var heroes: HeroesController = {
        let heroesViewModel = HeroesViewModel()
        let controller = HeroesController(viewModel: heroesViewModel, height: 100)
        heroesViewModel.selectHero
            .bind(to: self.viewModel.selectHeroById)
            .disposed(by: self.disposeBag)
        return controller
    }()

    private var header: UIView {
        let view = UIView(frame: .init(x: 0, y: 0, width: tableView.bounds.width, height: 100))
//        self.addChild(heroes)
        view.addSubview(heroes.view)
        heroes.view.setConstrainsEqualToParentEdges()
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Str.discover
        tableView.prefetchDataSource = self
        tableView.register(HeroFeedTableCell.self)
        tableView.rowHeight = 700
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        viewModel.reloadFields
            .asDriver(onErrorJustReturn: .all)
            .drive(onNext: { [weak self] row in
                if case let CollectionReload.insertItems(indexes) = row {
                    self?.tableView.reloadRows(at: indexes, with: .none)
                } else if case CollectionReload.all = row {
                    self?.tableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
        viewModel.error
                   .asDriver(onErrorJustReturn: "")
                   .drive(onNext: show(error:)).disposed(by: disposeBag)
    }
}

// MARK: - Table view data source

extension HeroFeedTableController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comicsList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HeroFeedTableCell.identifier, for: indexPath) as! HeroFeedTableCell
        cell.setData(of: comicsList[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return header
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }


}

// MARK: - UITableViewDataSourcePrefetching

extension HeroFeedTableController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        viewModel.prefetchItemsAt(prefetch: true, indexPaths: indexPaths)
    }

    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        viewModel.prefetchItemsAt(prefetch: false, indexPaths: indexPaths)
    }
}
