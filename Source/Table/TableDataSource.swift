//
//  TableDataSource.swift
//  FetchedDataSource
//
//  Created by David Jennes on 01/10/2018.
//

import CoreData
import UIKit

final class TableDataSource<ResultType: NSFetchRequestResult>: DataSource<ResultType>, UITableViewDataSource {
	private weak var view: UITableView?
	private weak var delegate: TableDataSourceDelegate?

	init(controller: NSFetchedResultsController<ResultType>, view: UITableView, delegate: TableDataSourceDelegate) {
		self.view = view
		self.delegate = delegate
		super.init(controller: controller)
	}

	override func finishSetup() {
		super.finishSetup()
		view?.dataSource = self
	}

	func object(for cell: UITableViewCell) -> ResultType? {
		guard let path = view?.indexPath(for: cell) else { return nil }
		return object(at: path)
	}

	// MARK: - UITableViewDataSource

	func numberOfSections(in tableView: UITableView) -> Int {
		return controller.sections?.count ?? 0
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard section < (controller.sections?.count ?? 0) else { return 0 }
		return controller.sections?[section].numberOfObjects ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let delegate = delegate else { fatalError("Delegate cannot be nil") }

		return delegate.cell(for: indexPath, view: tableView)
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return delegate?.titleForHeader(in: section, view: tableView, default: controller.sections?[section].name)
	}

	func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		return delegate?.titleForFooter(in: section, view: tableView)
	}

	func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		return delegate?.sectionIndexTitles(forView: tableView)
	}

	func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
		return delegate?.section(forSectionIndexTitle: title, at: index, view: tableView) ?? index
	}

	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return delegate?.canEditRow(at: indexPath, view: tableView) ?? false
	}

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		delegate?.commit(edit: editingStyle, forRowAt: indexPath, view: tableView)
	}

	func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return delegate?.canMoveItem(at: indexPath, view: tableView) ?? false
	}

	func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		delegate?.moveItem(at: sourceIndexPath, to: destinationIndexPath, view: tableView)
	}
}
