//
//  FetchedTableDataSource.swift
//  FetchedDataSource
//
//  Created by David Jennes on 27/12/16.
//  Copyright © 2016. All rights reserved.
//

import CoreData
import UIKit

class FetchedTableDataSource<FetchResult: NSFetchRequestResult, DelegateType: FetchedDataSourceDelegate where DelegateType.DataType == FetchResult, DelegateType.ViewType == UITableView, DelegateType.CellType == UITableViewCell> : FetchedDataSource<FetchResult, DelegateType>, UITableViewDataSource {

	override init(view: DelegateType.ViewType, controller: NSFetchedResultsController<FetchResult>, delegate: DelegateType) {
		super.init(view: view, controller: controller, delegate: delegate)

		defer {
			view.dataSource = self
		}
	}

	// MARK: - UITableViewDataSource

	func numberOfSections(in tableView: UITableView) -> Int {
		return controller.sections?.count ?? 0
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return controller.sections?[section].numberOfObjects ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let delegate = delegate else { fatalError() }
		let data = controller.object(at: indexPath)

		return delegate.cell(for: indexPath, data: data, view: tableView)
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return controller.sections?[section].name
	}

	// MARK: - NSFetchedResultsControllerDelegate

	public override func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		view?.beginUpdates()
	}

	public override func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		switch type {
		case .insert:
			if let newIndexPath = newIndexPath {
				changes.addObjectChange(type: type, path: newIndexPath)
			}
		case .delete:
			if let indexPath = indexPath {
				changes.addObjectChange(type: type, path: indexPath)
			}
		case .update:
			// avoid crash when updating non-visible rows:
			// http://stackoverflow.com/questions/11432556/nsrangeexception-exception-in-nsfetchedresultschangeupdate-event-of-nsfetchedres
			if let indexPath = indexPath, let _ = view?.indexPathsForVisibleRows?.index(of: indexPath) {
				changes.addObjectChange(type: type, path: indexPath)
			}
		case .move:
			if let indexPath = indexPath, let newIndexPath = newIndexPath {
				changes.addObjectMove(from: indexPath, to: newIndexPath)
			}
			break
		}
	}

	public override func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
		changes.addSectionChange(type: type, index: sectionIndex)
	}

	public override func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		view?.deleteSections(changes.deletedSections, with: animations?[.delete] ?? .automatic)
		view?.insertSections(changes.insertedSections, with: animations?[.insert] ?? .automatic)
		view?.reloadSections(changes.updatedSections, with: animations?[.update] ?? .automatic)
		view?.deleteRows(at: Array(changes.deletedObjects), with: animations?[.delete] ?? .automatic)
		view?.insertRows(at: Array(changes.insertedObjects), with: animations?[.insert] ?? .automatic)
		view?.reloadRows(at: Array(changes.updatedObjects), with: animations?[.update] ?? .automatic)
		for move in changes.movedObjects {
			view?.moveRow(at: move.from, to: move.to)
		}
		view?.endUpdates()

		changes = FetchedChanges()
	}
}
