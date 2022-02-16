//
//  CompositionalItem.swift
//  Example
//
//  Created by Jonathan Provo on 17/02/2022.
//  Copyright © 2022 Appwise. All rights reserved.
//

import FetchedDataSource

class CompositionalItem: CompositionalItemType {
	let section: String?
	let name: String?

	required init(managedObject: NSManagedObject) {
		section = managedObject.value(forKey: "section") as? String
		name = managedObject.value(forKey: "name") as? String
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(section)
		hasher.combine(name)
	}

	static func == (lhs: CompositionalItem, rhs: CompositionalItem) -> Bool {
		return lhs.section == rhs.section && lhs.name == rhs.name
	}
}
