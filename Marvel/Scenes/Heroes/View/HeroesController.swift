//
//  CollectionViewController.swift
//  Marvel
//
//  Created by abuzeid on 22.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class HeroesController: UICollectionViewController {
    private let viewModel: HeroesViewModelType
    let disposeBag = DisposeBag()

    init(viewModel: HeroesViewModelType) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    private var heroesList: [Hero] { viewModel.dataList }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView.allowsMultipleSelection = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        setupCollection()
        bindToViewModel()
    }
}

// MARK: - setup

private extension HeroesController {
    func bindToViewModel() {
        viewModel.reloadFields
            .asDriver(onErrorJustReturn: .all)
            .drive(onNext: collection(reload:))
            .disposed(by: disposeBag)

        viewModel.reloadFields.first()
            .asDriver(onErrorJustReturn: .all)
            .drive(onNext: { [weak self] _ in
                self?.selectCell(at: IndexPath(row: 0, section: 0))
            }).disposed(by: disposeBag)
        viewModel.isDataLoading
            .compactMap { $0 ? CGFloat(self.collectionView.bounds.height) : CGFloat(0) }
            .asDriver(onErrorJustReturn: 0)
            .drive(onNext: collectionView.updateFooterHeight(height:))
            .disposed(by: disposeBag)

        viewModel.error
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: show(error:))
            .disposed(by: disposeBag)

        viewModel.loadData()
    }

    func collection(reload: CollectionReload) {
        switch reload {
        case .all:
            collectionView.reloadData()
        case let .insertItems(paths):
            collectionView.insertItems(at: paths)
        }
    }

    func setupCollection() {
        collectionView.register(HeroCollectionCell.self)
        collectionView.register(ActivityIndicatorFooterView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: ActivityIndicatorFooterView.id)
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        collectionView.prefetchDataSource = self
        collectionView.contentInset = .init(top: 10, left: 10, bottom: 10, right: 10)
    }
}

// MARK: - UICollectionViewDataSource

extension HeroesController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.height - 20, height: collectionView.bounds.height)
    }
}

extension HeroesController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heroesList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroCollectionCell.identifier, for: indexPath) as! HeroCollectionCell
        cell.setData(with: heroesList[indexPath.row], isSelected: indexPath.row == viewModel.currentSelectedIndex)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: ActivityIndicatorFooterView.id,
                                                                   for: indexPath)

        default:
            fatalError("Unexpected element kind")
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectCell(at: indexPath)
    }

    private func selectCell(at indexPath: IndexPath) {
        guard indexPath.row < heroesList.count else { return }
        if let prevSelectedCell = collectionView.cellForItem(at: IndexPath(row: viewModel.currentSelectedIndex, section: 0)) as? HeroCollectionCell {
            prevSelectedCell.setSelected(false)
        }
        viewModel.selectHero(at: indexPath.row)

        guard let cell = collectionView.cellForItem(at: indexPath) as? HeroCollectionCell else { return }
        cell.setSelected(true)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
}

// MARK: - UICollectionViewDataSourcePrefetching

extension HeroesController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        viewModel.prefetchItemsAt(prefetch: true, indexPaths: indexPaths)
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        viewModel.prefetchItemsAt(prefetch: false, indexPaths: indexPaths)
    }
}

extension UIViewController {
    func show(error: String) {
        let alert = UIAlertController(title: nil, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Str.cancel, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
