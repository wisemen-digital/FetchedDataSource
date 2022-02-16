//
//  CompositionalStaticCollectionViewController.swift
//  Example
//
//  Created by Jonathan Provo on 17/02/2022.
//  Copyright © 2022 Appwise. All rights reserved.
//

import FetchedDataSource
import UIKit
import Reusable

@available(iOS 14.0, *)
class CompositionalStaticCollectionViewController: UICollectionViewController, FetchedCompositionalDataSourceDelegate {
	private var compositionalDataSource: FetchedCompositionalDataSource<CompositionalStaticSection, CompositionalItem>?
	private lazy var diffableDataSource: CompositionalStaticDataSource = {
		CompositionalStaticDataSource.createDataSource(collectionView: collectionView)
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		configureCollectionView()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		collectionView.collectionViewLayout.invalidateLayout()
	}

	private func configureCollectionView() {
		collectionView.collectionViewLayout = createLayout()
		collectionView.dataSource = diffableDataSource
		compositionalDataSource = .static(
			controllers: [
				CompositionalStaticSection.sectionOne: .init(controller: Item.allfrc),
				CompositionalStaticSection.sectionTwo: .init(controller: OtherItem.allfrc)
			],
			dataSource: diffableDataSource,
			delegate: self
		)
	}

	private func createLayout() -> UICollectionViewLayout {
		let sectionProvider = { (section: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
			guard let section = CompositionalStaticSection(rawValue: section) else { preconditionFailure("Should never be reached.") }
			var layoutSection: NSCollectionLayoutSection

			switch section {
			case .sectionOne:
				let itemSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
				let item: NSCollectionLayoutItem = .init(layoutSize: itemSize)
				let groupSize: NSCollectionLayoutSize = .init(widthDimension: .absolute(100), heightDimension: .absolute(100))
				let group: NSCollectionLayoutGroup = .horizontal(layoutSize: groupSize, subitems: [item])
				layoutSection = .init(group: group)
				layoutSection.orthogonalScrollingBehavior = .continuous

			case .sectionTwo:
				let itemSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
				let item: NSCollectionLayoutItem = .init(layoutSize: itemSize)
				let groupSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
				let group: NSCollectionLayoutGroup = .vertical(layoutSize: groupSize, subitems: [item])
				layoutSection = .init(group: group)
			}

			let headerSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30))
			let headerSupplementaryItem: NSCollectionLayoutBoundarySupplementaryItem = .init(layoutSize: headerSize, elementKind: "header", alignment: .top)
			layoutSection.boundarySupplementaryItems = [headerSupplementaryItem]
			layoutSection.contentInsets = .init(top: 0, leading: self.view.directionalLayoutMargins.leading, bottom: 0, trailing: self.view.directionalLayoutMargins.trailing)
			layoutSection.interGroupSpacing = 10
			return layoutSection
		}

		return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
	}
}
