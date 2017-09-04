//
//  FetchedTableDataSource.swift
//  FetchedDataSource
//
//  Created by David Jennes on 27/12/16.
//  Copyright © 2016. All rights reserved.
//

import CoreData
import UIKit

class FetchedTableDataSource<ResultType: NSFetchRequestResult, DelegateType: FetchedDataSourceDelegate where DelegateType.ViewType == UITableView, DelegateType.CellType == UITableViewCell> : FetchedDataSource<ResultType, DelegateType>, UITableViewDataSource {

	override init(view: DelegateType.ViewType, controller: ControllerType, delegate: DelegateType) {
		super.init(view: view, controller: controller, delegate: delegate)

		defer {
			view.dataSource = self
		}
	}

	public override func object(for cell: DelegateType.CellType) -> DelegateType.DataType? {
		guard let path = view?.indexPath(for: cell) else { return nil }
		return object(at: path)
	}

	// MARK: - UITableViewDataSource

	func numberOfSections(in tableView: UITableView) -> Int {
		return controller.sections?.count ?? 0
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return controller.sections?[section].numberOfObjects ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let delegate = delegate else { fatalError("Delegate cannot be nil") }

		let data = object(at: indexPath)
		let cell = delegate.cell(for: indexPath, data: data, view: tableView)

		return cell
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return controller.sections?[section].name
	}

	// MARK: - NSFetchedResultsControllerDelegate

	public override func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		super.controllerWillChangeContent(controller)
		view?.beginUpdates()
	}

	public override func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		super.controller(controller, didChange: anObject, at: indexPath, for: type, newIndexPath: newIndexPath)
		
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
		super.controller(controller, didChange: sectionInfo, atSectionIndex: sectionIndex, for: type)
		changes.addSectionChange(type: type, index: sectionIndex)
	}

	public override func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		if view?.window == nil {
			view?.reloadData()
		} else {
			apply(changes: changes)
			view?.endUpdates()
		}

		super.controllerDidChangeContent(controller)
		changes = FetchedChanges()
	}

	private func apply(changes: FetchedChanges) {
		view?.deleteSections(changes.deletedSections, with: animations?[.delete] ?? .automatic)
		view?.insertSections(changes.insertedSections, with: animations?[.insert] ?? .automatic)
		view?.reloadSections(changes.updatedSections, with: animations?[.update] ?? .automatic)
		view?.deleteRows(at: Array(changes.deletedObjects), with: animations?[.delete] ?? .automatic)
		view?.insertRows(at: Array(changes.insertedObjects), with: animations?[.insert] ?? .automatic)
		view?.reloadRows(at: Array(changes.updatedObjects), with: animations?[.update] ?? .automatic)
		for move in changes.movedObjects {
			view?.moveRow(at: move.from, to: move.to)
		}
	}
}
