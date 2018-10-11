//
//  StartViewController.swift
//  Example
//
//  Created by David Jennes on 28/12/2016.
//  Copyright © 2016 Appwise. All rights reserved.
//

import MagicalRecord
import UIKit

class StartViewController: UITableViewController {
	private var fetchedDataTimer: Timer? = nil

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)

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

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		fetchedDataTimer?.invalidate()
	}
}
