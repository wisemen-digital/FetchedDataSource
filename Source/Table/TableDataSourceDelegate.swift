//
//  TableDataSource.swift
//  FetchedDataSource
//
//  Created by David Jennes on 01/10/2018.
//

import CoreData
import UIKit

@objc public protocol TableDataSourceDelegate: AnyObject {
	@available(*, unavailable, renamed: "tableView(_:cellForRowAt:)")
	func cell(for indexPath: IndexPath, view: UITableView) -> UITableViewCell

	@available(*, unavailable, renamed: "tableView(_:canMoveRowAt:)")
	func canMoveItem(at indexPath: IndexPath, view: UITableView) -> Bool

	@available(*, unavailable, renamed: "tableView(_:moveRowAt:to:)")
	func moveItem(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath, view: UITableView)

	@available(*, unavailable, renamed: "tableView(_:titleForHeaderInSection:)")
	func titleForHeader(in section: Int, view: UITableView, default: String?) -> String?

	@available(*, unavailable, renamed: "tableView(_:titleForFooterInSection:)")
	func titleForFooter(in section: Int, view: UITableView) -> String?

	@available(*, unavailable, renamed: "tableView(_:canEditRowAt:)")
	func canEditRow(at indexPath: IndexPath, view: UITableView) -> Bool

	@available(*, unavailable, renamed: "tableView(_:commit:forRowAt:)")
	func commit(edit: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath, view: UITableView)

	@available(*, unavailable, renamed: "sectionIndexTitles(for:)")
	func sectionIndexTitles(forView view: UITableView) -> [String]?

	@available(*, unavailable, renamed: "tableView(_:sectionForSectionIndexTitle:at:)")
	func section(forSectionIndexTitle title: String, at index: Int, view: UITableView) -> Int
}
