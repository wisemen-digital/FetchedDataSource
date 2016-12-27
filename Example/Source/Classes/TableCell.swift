//
//  TableCell.swift
//  Example
//
//  Created by David Jennes on 24/12/2016.
//  Copyright © 2016 Appwise. All rights reserved.
//

import Reusable
import UIKit

class TableCell: UITableViewCell, Reusable {
	func configure(data: String) {
		textLabel?.text = data
		detailTextLabel?.text = "Wrapped Value"
	}

	func configure(item: Item) {
		textLabel?.text = item.name
		detailTextLabel?.text = "Fetched Value"
	}
}
