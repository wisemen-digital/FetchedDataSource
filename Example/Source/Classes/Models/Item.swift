//
//  Item.swift
//  Example
//
//  Created by David Jennes on 28/12/2016.
//  Copyright © 2016 Appwise. All rights reserved.
//

import CompoundFetchedResultsController
import MagicalRecord

extension Item {
	static var allfrc: NSFetchedResultsController<Item> {
		return Item.mr_fetchAllGrouped(by: nil,
									   with: nil,
									   sortedBy: "\(#keyPath(Item.section)),\(#keyPath(Item.name))",
									   ascending: true,
									   in: .mr_default()) as! NSFetchedResultsController<Item>
	}

	static var groupedfrc: NSFetchedResultsController<Item> {
		return Item.mr_fetchAllGrouped(by: #keyPath(Item.section),
		                               with: nil,
		                               sortedBy: "\(#keyPath(Item.section)),\(#keyPath(Item.name))",
									   ascending: true,
									   in: .mr_default()) as! NSFetchedResultsController<Item>
	}

	static var staticfrc: StaticFetchedResultsController<Item> {
		let items: [Item] = Item.mr_findAllSorted(by: "\(#keyPath(Item.section)),\(#keyPath(Item.name))",
												  ascending: true,
												  in: .mr_default()) as! [Item]

		return StaticFetchedResultsController(items: items, sectionTitle: "")
	}
}
