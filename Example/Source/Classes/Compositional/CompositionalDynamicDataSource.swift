//
//  CompositionalDynamicDataSource.swift
//  Example
//
//  Created by Jonathan Provo on 17/02/2022.
//  Copyright © 2022 Appwise. All rights reserved.
//

import FetchedDataSource
import UIKit

@available(iOS 14.0, *)
typealias CompositionalDynamicDataSource = UICollectionViewDiffableDataSource<CompositionalDynamicSection, CompositionalItem>
@available(iOS 14.0, *)
typealias CompositionalDynamicSnapshot = NSDiffableDataSourceSnapshot<CompositionalDynamicSection, CompositionalItem>

class CompositionalDynamicSection: CompositionalSectionType {
	private let identifier: String

	required init?(identifier: String) {
		self.identifier = identifier
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(identifier)
	}

	static func == (lhs: CompositionalDynamicSection, rhs: CompositionalDynamicSection) -> Bool {
		return lhs.identifier == rhs.identifier
	}
}

@available(iOS 14.0, *)
extension CompositionalDynamicDataSource {
	static func createDataSource(collectionView: UICollectionView) -> CompositionalDynamicDataSource {
		let headerRegistration = UICollectionView.SupplementaryRegistration<TitleHeader>(elementKind: "header") { supplementaryView, elementKind, indexPath in
			guard let diffableDataSource = collectionView.dataSource as? CompositionalDynamicDataSource else { return }
			supplementaryView.titleLabel.text = diffableDataSource.itemIdentifier(for: indexPath)?.section
		}
		let cellRegistration = UICollectionView.CellRegistration<CollectionCell, String?> { cell, _, itemIdentifier in
			cell.configure(name: itemIdentifier)
		}

		let cellProvider: CompositionalDynamicDataSource.CellProvider = { collectionView, indexPath, itemIdentifier in
			return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier.name)
		}
		let supplementaryViewProvider: CompositionalDynamicDataSource.SupplementaryViewProvider = { collectionView, elementKind, indexPath in
			guard elementKind == "header" else { preconditionFailure("Should never be reached.") }
			return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
		}

		let dataSource: CompositionalDynamicDataSource = .init(collectionView: collectionView, cellProvider: cellProvider)
		dataSource.supplementaryViewProvider = supplementaryViewProvider
		return dataSource
	}
}
