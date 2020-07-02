//
//  CollectionDataSource.swift
//  FetchedDataSource
//
//  Created by David Jennes on 01/10/2018.
//

import CoreData
import UIKit

@objc public protocol CollectionDataSourceDelegate: AnyObject {
	@available(*, unavailable, renamed: "collectionView(_:cellForItemAt:)")
	func cell(for indexPath: IndexPath, view: UICollectionView) -> UICollectionViewCell

	@available(*, unavailable, renamed: "collectionView(_:canMoveItemAt:)")
	func canMoveItem(at indexPath: IndexPath, view: UICollectionView) -> Bool

	@available(*, unavailable, renamed: "collectionView(_:moveItemAt:to:)")
	func moveItem(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath, view: UICollectionView)

	@available(*, unavailable, renamed: "collectionView(_:viewForSupplementaryElementOfKind:at:)")
	func view(of kind: String, at indexPath: IndexPath, view: UICollectionView) -> UICollectionReusableView?
}
