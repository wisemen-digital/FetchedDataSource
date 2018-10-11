//
//  TableViewController.swift
//  Example
//
//  Created by David Jennes on 23/12/16.
//  Copyright © 2016 dj. All rights reserved.
//

import CoreData
import FetchedDataSource
import Reusable

class StaticWithItemTableViewController: UITableViewController {
	var fetchedDataSource: FetchedTableDataSource<StaticWithItemTableViewController>!

	override func viewDidLoad() {
		super.viewDidLoad()

		fetchedDataSource = FetchedDataSource.for(tableView: tableView, controller: Item.staticfrc, delegate: self)
	}
}

extension StaticWithItemTableViewController: FetchedTableDataSourceDelegate {
	func cell(for indexPath: IndexPath, data: Item, view: UITableView) -> UITableViewCell {
		let cell = view.dequeueReusableCell(for: indexPath) as TableCell

		cell.configure(item: data)

		return cell
	}
}
