//
//  TableDataSource.swift
//  FetchedDataSource
//
//  Created by David Jennes on 01/10/2018.
//

import CoreData
import UIKit

public protocol TableDataSourceDelegate: AnyObject {
	/// Asks your delegate for the cell that corresponds to the specified item in the view.
	///
	/// - Parameter view: The view requesting this information.
	/// - Parameter indexPath: The index path that specifies the location of the item.
	/// - Returns: A configured cell object.
	func cell(for indexPath: IndexPath, view: UITableView) -> UITableViewCell

	/// Asks your delegate whether the specified item can be moved to another location in the view.
	/// Use this method to selectively allow or disallow the movement of items within the view.
	///
	/// **Note**: If you do not implement this method, the default implementation will return `false`.
	///
	/// - Parameter view: The view requesting this information.
	/// - Parameter indexPath: The index path of the item that the view is trying to move.
	/// - Returns: `true` if the item is allowed to move or `false` if it is not.
	func canMoveItem(at indexPath: IndexPath, view: UITableView) -> Bool

	/// Tells your delegate to move the specified item to its new location.
	///
	/// - Parameter view: The view notifying you of the move.
	/// - Parameter sourceIndexPath: The item’s original index path.
	/// - Parameter destinationIndexPath: The new index path of the item.
	func moveItem(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath, view: UITableView)

	func titleForHeader(in section: Int, view: UITableView, default: String?) -> String?
	func titleForFooter(in section: Int, view: UITableView) -> String?

	func canEditRow(at indexPath: IndexPath, view: UITableView) -> Bool
	func commit(edit: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath, view: UITableView)

	func sectionIndexTitles(forView view: UITableView) -> [String]?
	func section(forSectionIndexTitle title: String, at index: Int, view: UITableView) -> Int
}

public extension TableDataSourceDelegate {
	func canMoveItem(at indexPath: IndexPath, view: UITableView) -> Bool {
		return false
	}

	func moveItem(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath, view: UITableView) {
	}

	func titleForHeader(in section: Int, view: UITableView, default: String?) -> String? {
		return `default`
	}

	func titleForFooter(in section: Int, view: UITableView) -> String? {
		return nil
	}

	func canEditRow(at indexPath: IndexPath, view: UITableView) -> Bool {
		return false
	}

	func commit(edit: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath, view: UITableView) {
	}

	func sectionIndexTitles(forView view: UITableView) -> [String]? {
		return nil
	}

	func section(forSectionIndexTitle title: String, at index: Int, view: UITableView) -> Int {
		return index
	}
}
