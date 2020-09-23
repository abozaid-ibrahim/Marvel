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
    private let height: CGFloat
    let disposeBag = DisposeBag()

    init(viewModel: HeroesViewModelType, height: CGFloat = 0) {
        self.viewModel = viewModel
        self.height = height
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
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
//        collectionView.scrollIndicatorInsets = .zero
        setupCollection()
        bindToViewModel()
    }
}

// MARK: - setup

private extension HeroesController {
    func show(error: String) {
        let alert = UIAlertController(title: nil, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Str.cancel, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func bindToViewModel() {
        viewModel.reloadFields
            .asDriver(onErrorJustReturn: .all)
            .drive(onNext: collection(reload:))
            .disposed(by: disposeBag)

        viewModel.isDataLoading
            .compactMap { [unowned self] in $0 ? CGFloat(self.height) : CGFloat(0) }
            .asDriver(onErrorJustReturn: 0)
            .drive(onNext: collectionView.updateFooterHeight(height:)).disposed(by: disposeBag)

        viewModel.error
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: show(error:)).disposed(by: disposeBag)

        viewModel.loadData()
    }

    func collection(reload: CollectionReload) {
        switch reload {
        case .all:
            collectionView.reloadData()
            DispatchQueue.main.async {
                self.collectionView(self.collectionView, didSelectItemAt: IndexPath(row: 0, section: 0))
            }
        case let .insertItems(paths):
            collectionView.insertItems(at: paths)
        }
    }

    func setupCollection() {
        collectionView.register(HeroCollectionCell.self)
        collectionView.register(ActivityIndicatorFooterView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: ActivityIndicatorFooterView.id)
        collectionView.setCell(size: .with(width: height - 20, height: height))
        collectionView.prefetchDataSource = self
    }

    
}

// MARK: - UICollectionViewDataSource

extension HeroesController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heroesList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroCollectionCell.identifier, for: indexPath) as! HeroCollectionCell
        cell.setData(with: heroesList[indexPath.row])
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
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
        viewModel.selectHero.onNext(heroesList[indexPath.row].id)
        guard let cell = collectionView.cellForItem(at: indexPath) as? HeroCollectionCell else { return }
        cell.set(isSelected: true)
        // TODO: add margin before item
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }

    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? HeroCollectionCell else { return }
        cell.set(isSelected: false)
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
