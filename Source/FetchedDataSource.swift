//
//  FetchedDataSource.swift
//  FetchedDataSource
//
//  Created by David Jennes on 27/12/16.
//  Copyright © 2016. All rights reserved.
//

import CoreData
import UIKit

public class FetchedDataSource<ResultType: NSFetchRequestResult, DelegateType: FetchedDataSourceDelegate>: NSObject, NSFetchedResultsControllerDelegate {
	public typealias ControllerType = NSFetchedResultsController<ResultType>

	public let controller: ControllerType
	public var animateChanges: Bool
	weak var delegate: DelegateType?
	weak var view: DelegateType.ViewType?
	lazy var changes = FetchedChanges()
	var isVisible = true
	var monitor: LifecycleBehaviorViewController<ResultType, DelegateType>!

	internal init(view: DelegateType.ViewType, controller: ControllerType, delegate: DelegateType, animateChanges: Bool) {
		self.controller = controller
		self.view = view
		self.delegate = delegate
		self.animateChanges = animateChanges

		defer {
			controller.delegate = self

			// monitor visibility
			monitor = LifecycleBehaviorViewController(source: self)
			if let vc = delegate as? UIViewController {
				vc.addChildViewController(monitor)
				vc.view.addSubview(monitor.view)
				monitor.didMove(toParentViewController: vc)
			}
		}

		super.init()
	}

	// MARK: - Helper methods

	/// Try to find the index path for a given object.
	///
	/// - Parameter object: The object to search for.
	/// - Returns: The index path for the object (if found) or `nil`.
	public func index(for object: DelegateType.DataType) -> IndexPath? {
		if let object = object as? ResultType {
			return controller.indexPath(forObject: object)
		} else {
			fatalError("Unable to cast object of type '\(DelegateType.DataType.self)' to \(ResultType.self)")
		}
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
	public func object(at indexPath: IndexPath) -> DelegateType.DataType {
		guard contains(indexPath: indexPath) else { fatalError("The index path is out of bounds for the controller: \(indexPath)") }

		if let object = controller.object(at: indexPath) as? DelegateType.DataType {
			return object
		} else {
			fatalError("Unable to cast object of type `\(ResultType.self)` to `\(DelegateType.DataType.self)`")
		}
	}

	/// Try to find the object corresponding to a cell.
	///
	/// - Parameter object: The cell to search for.
	/// - Returns: The object matching the cell (if found) or `nil`.
	public func object(for cell: DelegateType.CellType) -> DelegateType.DataType? {
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

	// MARK: - Empty NSFetchedResultsControllerDelegate methods
	// Needed for correct method dispatch

	public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		delegate?.willChangeContent()
	}

	public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
	}

	public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
	}

	public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		delegate?.didChangeContent()
	}
}
