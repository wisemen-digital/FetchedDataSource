//
//  FetchedTableDataSource.swift
//  FetchedDataSource
//
//  Created by David Jennes on 27/12/16.
//  Copyright © 2016. All rights reserved.
//

import CoreData
import UIKit

class FetchedTableDataSource<ResultType: NSFetchRequestResult, DelegateType: FetchedTableDataSourceDelegate>: FetchedDataSource<ResultType, DelegateType>, UITableViewDataSource {

	/**
	Dictionary to configure the different animations to be applied by each change type.
	*/
	public var animations: [NSFetchedResultsChangeType: UITableViewRowAnimation]?

	override init(view: DelegateType.ViewType, controller: ControllerType, delegate: DelegateType, animateChanges: Bool = true) {
		super.init(view: view, controller: controller, delegate: delegate, animateChanges: animateChanges)

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
		return delegate?.titleForHeader(in: section, view: tableView, default: controller.sections?[section].name)
	}

	func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		return delegate?.titleForFooter(in: section, view: tableView)
	}

	func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		return delegate?.sectionIndexTitles(for: tableView)
	}

	func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
		return delegate?.section(forSectionIndexTitle: title, at: index, view: tableView) ?? index
	}

	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return delegate?.canEditRow(at: indexPath, view: tableView) ?? false
	}

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		delegate?.commit(edit: editingStyle, forRowAt: indexPath, view: tableView)
	}

	func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return delegate?.canMoveItem(at: indexPath, view: tableView) ?? false
	}

	func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		delegate?.moveItem(at: sourceIndexPath, to: destinationIndexPath, view: tableView)
	}

	// MARK: - NSFetchedResultsControllerDelegate

	public override func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		super.controllerWillChangeContent(controller)
		if shouldAnimateChanges {
			view?.beginUpdates()
		}
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
		if shouldAnimateChanges {
			apply(changes: changes)
			view?.endUpdates()
		} else {
			view?.reloadData()
		}

		super.controllerDidChangeContent(controller)
		changes = FetchedChanges()
	}

	private var shouldAnimateChanges: Bool {
		return isVisible && view?.window != nil && animateChanges
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
