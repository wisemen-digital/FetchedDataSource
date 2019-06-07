//
//  FetchedDataSource.swift
//  FetchedDataSource
//
//  Created by David Jennes on 27/12/16.
//  Copyright © 2016. All rights reserved.
//

import CoreData
import UIKit

public class __FetchedDataSource<ResultType: NSFetchRequestResult, CellType: UIView> {
	public let controller: NSFetchedResultsController<ResultType>

	internal init(controller: NSFetchedResultsController<ResultType>) {
		self.controller = controller
	}

	// MARK: - Helper methods

	/// Try to find the index path for a given object.
	///
	/// - Parameter object: The object to search for.
	/// - Returns: The index path for the object (if found) or `nil`.
	public func index(for object: ResultType) -> IndexPath? {
		return controller.indexPath(forObject: object)
	}

	/// Check if the controller contains the given index path (section and row/item).
	///
	/// - Parameter indexPath: The index path to check.
	/// - Returns: True if the path is within bounds.
	public func contains(indexPath: IndexPath) -> Bool {
		return indexPath.section < (controller.sections?.count ?? 0) &&
			indexPath.row < (controller.sections?[indexPath.section].numberOfObjects ?? 0)
	}

	/// A Boolean value indicating whether the controller is empty.
	public var isEmpty: Bool {
		return controller.fetchedObjects?.isEmpty ?? true
	}

	/// Try to get the object at the given index path.
	/// Note: this function will fatalError if the path is out of bounds.
	///
	/// - Parameter indexPath: The index path to fetch.
	/// - Returns: The requested object (if within bounds).
	public func object(at indexPath: IndexPath) -> ResultType {
		precondition(contains(indexPath: indexPath), "The index path is out of bounds for the controller: \(indexPath)")
		return controller.object(at: indexPath)
	}

	/// Try to find the object corresponding to a cell.
	///
	/// - Parameter object: The cell to search for.
	/// - Returns: The object matching the cell (if found) or `nil`.
	public func object(for cell: CellType) -> ResultType? {
		return nil
	}

	/// Get the section information for a given index.
	///
	/// - Parameter section: The section's index.
	/// - Returns: The section information (if within bounds) or `nil`.
	public func section(at section: Int) -> NSFetchedResultsSectionInfo? {
		guard section < (controller.sections?.count ?? 0) else { return nil }
		return controller.sections?[section]
	}
}
