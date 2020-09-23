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
    private var comicsList: [FeedResult] { viewModel.dataList }
    private let disposeBag = DisposeBag()
    init(viewModel: HeroFeedViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(HeroFeedTableCell.self)
        tableView.rowHeight = 500
        tableView.estimatedRowHeight = 500
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
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comicsList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HeroFeedTableCell.identifier, for: indexPath) as! HeroFeedTableCell
        cell.setData(of: comicsList[indexPath.row])
        return cell
    }
}
