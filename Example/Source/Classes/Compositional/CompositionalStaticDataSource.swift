//
//  CompositionalStaticDataSource.swift
//  Example
//
//  Created by Jonathan Provo on 17/02/2022.
//  Copyright © 2022 Appwise. All rights reserved.
//

import FetchedDataSource
import UIKit

@available(iOS 14.0, *)
typealias CompositionalStaticDataSource = UICollectionViewDiffableDataSource<CompositionalStaticSection, CompositionalItem>
@available(iOS 14.0, *)
typealias CompositionalStaticSnapshot = NSDiffableDataSourceSnapshot<CompositionalStaticSection, CompositionalItem>

enum CompositionalStaticSection: Int, CompositionalSectionType {
	case sectionOne = 0
	case sectionTwo = 1

	var index: Int {
		rawValue
	}

	var title: String {
		switch self {
		case .sectionOne:
			return "Section one"
		case .sectionTwo:
			return "Section two"
		}
	}
}

@available(iOS 14.0, *)
extension CompositionalStaticDataSource {
	static func createDataSource(collectionView: UICollectionView) -> CompositionalStaticDataSource {
		let headerRegistration = UICollectionView.SupplementaryRegistration<TitleHeader>(elementKind: "header") { supplementaryView, elementKind, indexPath in
			guard let section = CompositionalStaticSection(rawValue: indexPath.section) else { preconditionFailure("Should never be reached.") }
			supplementaryView.titleLabel.text = section.title
		}
		let cellRegistration = UICollectionView.CellRegistration<CollectionCell, String?> { cell, _, itemIdentifier in
			cell.configure(name: itemIdentifier)
		}

		let cellProvider: CompositionalStaticDataSource.CellProvider = { collectionView, indexPath, itemIdentifier in
			return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier.name)
		}
		let supplementaryViewProvider: CompositionalStaticDataSource.SupplementaryViewProvider = { collectionView, elementKind, indexPath in
			guard elementKind == "header" else { preconditionFailure("Should never be reached.") }
			return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
		}

		let dataSource: CompositionalStaticDataSource = .init(collectionView: collectionView, cellProvider: cellProvider)
		dataSource.supplementaryViewProvider = supplementaryViewProvider
		return dataSource
	}
}
