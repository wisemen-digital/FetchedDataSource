//
//  StartViewController.swift
//  Example
//
//  Created by David Jennes on 23/12/16.
//  Copyright © 2016 dj. All rights reserved.
//

import CompoundFetchedResultsController
import CoreData
import FetchedDataSource
import MagicalRecord
import Reusable

class TableViewController: UITableViewController {
	var frc: NSFetchedResultsController<NSFetchRequestResult>!
	var fetchedDataSource: FetchedDataSource<NSFetchRequestResult, TableViewController>!

	private var fetchedDataTimer: Timer?

	override func viewDidLoad() {
		super.viewDidLoad()

		fetchedDataSource = FetchedDataSource.for(tableView: tableView, controller: frc, delegate: self)
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		fetchedDataTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
			MagicalRecord.save({ moc in
				var items = Item.mr_findAll(in: moc) as! [Item]

				// delete random # of items
				let delete = arc4random_uniform(UInt32(items.count))
				for _ in 0..<delete {
					let item = Int(arc4random_uniform(UInt32(items.count)))
					items[item].mr_deleteEntity(in: moc)
					items.remove(at: item)
				}

				// update random # of items
				let update = arc4random_uniform(UInt32(items.count))
				for _ in 0..<update {
					let item = Int(arc4random_uniform(UInt32(items.count)))
					items[item].name = UUID().uuidString
				}

				// create random new items
				let create = arc4random_uniform(10)
				for _ in 0..<create {
					let item = Item.mr_createEntity(in: moc)
					item?.name = UUID().uuidString
					item?.section = String(arc4random_uniform(3))
				}

				NSLog("Updated fetched items: \(delete) deletes, \(update) updates and \(create) creates")
			})
		}
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		fetchedDataTimer?.invalidate()
	}
}

extension TableViewController: FetchedDataSourceDelegate {
	func cell(for indexPath: IndexPath, data: NSFetchRequestResult, view: UITableView) -> UITableViewCell {
		let cell = view.dequeueReusableCell(for: indexPath) as TableCell

		if let item = data as? ValueWrapper<String> {
			cell.configure(data: item.value)
		} else if let item = data as? Item {
			cell.configure(item: item)
		}

		return cell
	}
}
