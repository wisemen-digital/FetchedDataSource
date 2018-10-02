//
//  CollectionDataSource.swift
//  FetchedDataSource
//
//  Created by David Jennes on 01/10/2018.
//

import CoreData
import UIKit

public protocol CollectionDataSourceDelegate: AnyObject {
	associatedtype ResultType: NSFetchRequestResult

	/// Asks your delegate for the cell that corresponds to the specified item in the view.
	///
	/// - Parameter view: The view requesting this information.
	/// - Parameter indexPath: The index path that specifies the location of the item.
	/// - Parameter indexPath: The data object to configure the cell.
	/// - Returns: A configured cell object.
	func cell(for indexPath: IndexPath, data: ResultType, view: UICollectionView) -> UICollectionViewCell

	/// Asks your delegate whether the specified item can be moved to another location in the view.
	/// Use this method to selectively allow or disallow the movement of items within the view.
	///
	/// **Note**: If you do not implement this method, the default implementation will return `false`.
	///
	/// - Parameter view: The view requesting this information.
	/// - Parameter indexPath: The index path of the item that the view is trying to move.
	/// - Returns: `true` if the item is allowed to move or `false` if it is not.
	func canMoveItem(at indexPath: IndexPath, view: UICollectionView) -> Bool

	/// Tells your delegate to move the specified item to its new location.
	///
	/// - Parameter view: The view notifying you of the move.
	/// - Parameter sourceIndexPath: The item’s original index path.
	/// - Parameter destinationIndexPath: The new index path of the item.
	func moveItem(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath, view: UICollectionView)

	func view(of kind: String, at indexPath: IndexPath, view: UICollectionView) -> UICollectionReusableView?
}

public extension CollectionDataSourceDelegate {
	func canMoveItem(at indexPath: IndexPath, view: UICollectionView) -> Bool {
		return false
	}

	func moveItem(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath, view: UICollectionView) {
	}

	func view(of kind: String, at indexPath: IndexPath, view: UICollectionView) -> UICollectionReusableView? {
		return nil
	}
}
