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

	private var deletedSections = IndexSet()
	private var insertedSections = IndexSet()
	private var reloadedSections = IndexSet()
	private var deletedRows = [IndexPath]()
	private var insertedRows = [IndexPath]()
	private var reloadedRows = [IndexPath]()

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
			if !insertedSections.contains(newIndexPath!.section) && !reloadedSections.contains(newIndexPath!.section) {
				insertedRows.append(newIndexPath!)
			}
		case .delete:
			if !deletedSections.contains(indexPath!.section) && !reloadedSections.contains(indexPath!.section) {
				deletedRows.append(indexPath!)
			}
		case .update:
			reloadedRows.append(indexPath!)
		case .move:
			if !deletedSections.contains(indexPath!.section) && !reloadedSections.contains(indexPath!.section) {
				deletedRows.append(indexPath!)
			}
			if !insertedSections.contains(newIndexPath!.section) && !reloadedSections.contains(newIndexPath!.section) {
				insertedRows.append(newIndexPath!)
			}
		}
	}

	public override func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
		switch type {
		case .insert:
			insertedSections.insert(sectionIndex)
		case .delete:
			deletedSections.insert(sectionIndex)
		case .update:
			reloadedSections.insert(sectionIndex)
		default:
			break
		}
	}

	public override func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		view?.deleteSections(deletedSections, with: animations?[.delete] ?? .automatic)
		view?.insertSections(insertedSections, with: animations?[.insert] ?? .automatic)
		view?.reloadSections(reloadedSections, with: animations?[.update] ?? .automatic)
		view?.deleteRows(at: deletedRows, with: animations?[.delete] ?? .automatic)
		view?.insertRows(at: insertedRows, with: animations?[.insert] ?? .automatic)
		view?.reloadRows(at: reloadedRows, with: animations?[.update] ?? .automatic)
		view?.endUpdates()

		deletedSections = IndexSet()
		insertedSections = IndexSet()
		reloadedSections = IndexSet()
		deletedRows = [IndexPath]()
		insertedRows = [IndexPath]()
		reloadedRows = [IndexPath]()
	}
}
