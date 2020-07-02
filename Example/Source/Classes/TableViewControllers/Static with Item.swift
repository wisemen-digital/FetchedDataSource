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
	var fetchedDataSource: FetchedTableDataSource<Item>!

	override func viewDidLoad() {
		super.viewDidLoad()

		fetchedDataSource = FetchedTableDataSource(controller: Item.staticfrc, view: tableView, delegate: self)
	}
}

extension StaticWithItemTableViewController: FetchedTableDataSourceDelegate {
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(for: indexPath) as TableCell

		if let item = fetchedDataSource.object(at: indexPath) {
			cell.configure(item: item)
		}

		return cell
	}
}
