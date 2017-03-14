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

	let controller: ControllerType
	weak var delegate: DelegateType?
	weak var view: DelegateType.ViewType?
	lazy var changes = FetchedChanges()

	/**
	Dictionary to configurate the different animations to be applied by each change type.
	*/
	public var animations: [NSFetchedResultsChangeType: UITableViewRowAnimation]?

	internal init(view: DelegateType.ViewType, controller: ControllerType, delegate: DelegateType) {
		self.controller = controller
		self.view = view
		self.delegate = delegate

		defer {
			controller.delegate = self
		}

		super.init()
	}

	// MARK: - Helper methods
	
	public func index(for object: DelegateType.DataType) -> IndexPath? {
		if let object = object as? ResultType {
			return controller.indexPath(forObject: object)
		} else {
			fatalError("Unable to cast object of type '\(DelegateType.DataType.self)' to \(ResultType.self)")
		}
	}

	public func object(at indexPath: IndexPath) -> DelegateType.DataType {
		if let object = controller.object(at: indexPath) as? DelegateType.DataType {
			return object
		} else {
			fatalError("Unable to cast object of type `\(ResultType.self)` to `\(DelegateType.DataType.self)`")
		}
	}

	public func object(for cell: DelegateType.CellType) -> DelegateType.DataType? {
		return nil
	}

	// MARK: - Empty NSFetchedResultsControllerDelegate methods
	// Needed for correct method dispatch

	public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
	}

	public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
	}

	public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
	}

	public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
	}
}
