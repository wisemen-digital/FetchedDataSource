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
	func configure(item: Item) {
		textLabel?.text = item.name
		detailTextLabel?.text = "Fetched Value"
	}
}

class CollectionCell: UICollectionViewCell, Reusable {
	@IBOutlet var textLabel: UILabel!
	@IBOutlet var detailTextLabel: UILabel!

	func configure(item: Item) {
		textLabel.text = item.name
		detailTextLabel.text = "Fetched Value"
	}
}

public final class TitleHeader: UICollectionReusableView, Reusable {
	@IBOutlet public var titleLabel: UILabel!
}
