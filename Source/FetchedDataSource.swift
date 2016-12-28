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

	func cell(for indexPath: IndexPath, data: DataType, view: ViewType) -> CellType
}

public class FetchedDataSource<FetchResult: NSFetchRequestResult, DelegateType: FetchedDataSourceDelegate>: NSObject, NSFetchedResultsControllerDelegate {

	let controller: NSFetchedResultsController<FetchResult>
	weak var delegate: DelegateType?
	weak var view: DelegateType.ViewType?

	/**
	Dictionary to configurate the different animations to be applied by each change type.
	*/
	public var animations: [NSFetchedResultsChangeType: UITableViewRowAnimation]?

	internal init(view: DelegateType.ViewType, controller: NSFetchedResultsController<FetchResult>, delegate: DelegateType) {
		self.controller = controller
		self.view = view
		self.delegate = delegate

		defer {
			controller.delegate = self
		}

		super.init()
	}

	public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
	}

	public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
	}

	public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
	}

	public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
	}
}

public extension FetchedDataSource where DelegateType: FetchedDataSourceDelegate, FetchResult == DelegateType.DataType, DelegateType.ViewType == UITableView, DelegateType.CellType == UITableViewCell {
	static func `for`(tableView: DelegateType.ViewType, controller: NSFetchedResultsController<FetchResult>, delegate: DelegateType) -> FetchedDataSource<FetchResult, DelegateType> {
		return FetchedTableDataSource<FetchResult, DelegateType>(view: tableView, controller: controller, delegate: delegate)
	}
}

public extension FetchedDataSource where DelegateType: FetchedDataSourceDelegate, FetchResult == DelegateType.DataType, DelegateType.ViewType == UICollectionView, DelegateType.CellType == UICollectionViewCell {
	static func `for`(collectionView: DelegateType.ViewType, controller: NSFetchedResultsController<FetchResult>, delegate: DelegateType) -> FetchedDataSource<FetchResult, DelegateType> {
		return FetchedCollectionDataSource<FetchResult, DelegateType>(view: collectionView, controller: controller, delegate: delegate)
	}
}
