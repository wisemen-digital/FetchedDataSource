//
//  FetchedDataSource.swift
//  FetchedDataSource
//
//  Created by David Jennes on 27/12/16.
//  Copyright © 2016. All rights reserved.
//

import CoreData
import UIKit

public protocol FetchedDataSourceDelegate: class {
	associatedtype DataType: NSFetchRequestResult
	associatedtype ViewType: UIView
	associatedtype CellType: UIView

	/// Called when the controller will trigger content changes.
	func willChangeContent()

	/// Called when the controller has finished with content changes.
	func didChangeContent()

	/// Asks your delegate for the cell that corresponds to the specified item in the view.
	///
	/// - Parameter view: The view requesting this information.
	/// - Parameter indexPath: The index path that specifies the location of the item.
	/// - Parameter indexPath: The data object to configure the cell.
	/// - Returns: A configured cell object.
	func cell(for indexPath: IndexPath, data: DataType, view: ViewType) -> CellType

	/// Asks your delegate whether the specified item can be moved to another location in the view.
	/// Use this method to selectively allow or disallow the movement of items within the view.
	///
	/// **Note**: If you do not implement this method, the default implementation will return `false`.
	///
	/// - Parameter view: The view requesting this information.
	/// - Parameter indexPath: The index path of the item that the view is trying to move.
	/// - Returns: `true` if the item is allowed to move or `false` if it is not.
	func canMoveItem(at indexPath: IndexPath, view: ViewType) -> Bool

	/// Tells your delegate to move the specified item to its new location.
	///
	/// - Parameter view: The view notifying you of the move.
	/// - Parameter sourceIndexPath: The item’s original index path.
	/// - Parameter destinationIndexPath: The new index path of the item.
	func moveItem(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath, view: ViewType)
}

public extension FetchedDataSourceDelegate {
	func willChangeContent() {
	}
	
	func didChangeContent() {
	}

	func canMoveItem(at indexPath: IndexPath, view: ViewType) -> Bool {
		return false
	}

	func moveItem(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath, view: ViewType) {
	}
}

// MARK: - Table Delegate

public protocol FetchedTableDataSourceDelegate: FetchedDataSourceDelegate where ViewType == UITableView, CellType == UITableViewCell {
	func titleForHeader(in section: Int, view: ViewType, default: String?) -> String?
	func titleForFooter(in section: Int, view: ViewType) -> String?

	func canEditRow(at indexPath: IndexPath, view: ViewType) -> Bool
	func commit(edit: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath, view: ViewType)

	func sectionIndexTitles(forView view: ViewType) -> [String]?
	func section(forSectionIndexTitle title: String, at index: Int, view: ViewType) -> Int
}

public extension FetchedTableDataSourceDelegate {
	func titleForHeader(in section: Int, view: ViewType, default: String?) -> String? {
		return `default`
	}

	func titleForFooter(in section: Int, view: ViewType) -> String? {
		return nil
	}

	func canEditRow(at indexPath: IndexPath, view: ViewType) -> Bool {
		return false
	}

	func commit(edit: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath, view: ViewType) {
	}

	func sectionIndexTitles(forView view: ViewType) -> [String]? {
		return nil
	}

	func section(forSectionIndexTitle title: String, at index: Int, view: ViewType) -> Int {
		return index
	}
}

// MARK: - Collection Delegate

public protocol FetchedCollectionDataSourceDelegate: FetchedDataSourceDelegate where ViewType == UICollectionView, CellType == UICollectionViewCell {
	func view(of kind: String, at indexPath: IndexPath, view: ViewType) -> UICollectionReusableView?
}

public extension FetchedCollectionDataSourceDelegate {
	func view(of kind: String, at indexPath: IndexPath, view: ViewType) -> UICollectionReusableView? {
		return nil
	}
}
