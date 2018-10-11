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

class NSFetchedResultsControllerTableViewController: UITableViewController {
	var fetchedDataSource: FetchedTableDataSource<NSFetchedResultsControllerTableViewController>!

	override func viewDidLoad() {
		super.viewDidLoad()

		fetchedDataSource = FetchedDataSource.for(tableView: tableView, controller: Item.nsfrc, delegate: self)
	}
}

extension NSFetchedResultsControllerTableViewController: FetchedTableDataSourceDelegate {
	func cell(for indexPath: IndexPath, data: Item, view: UITableView) -> UITableViewCell {
		let cell = view.dequeueReusableCell(for: indexPath) as TableCell

		cell.configure(item: data)

		return cell
	}
}

class NSFetchedResultsControllerCollectionViewController: UICollectionViewController {
	var fetchedDataSource: FetchedCollectionDataSource<NSFetchedResultsControllerCollectionViewController>!

	override func viewDidLoad() {
		super.viewDidLoad()

		fetchedDataSource = FetchedDataSource.for(collectionView: collectionView!, controller: Item.nsfrc, delegate: self)
	}
}

extension NSFetchedResultsControllerCollectionViewController: FetchedCollectionDataSourceDelegate {
	func cell(for indexPath: IndexPath, data: Item, view: UICollectionView) -> UICollectionViewCell {
		let cell = view.dequeueReusableCell(for: indexPath) as CollectionCell

		cell.configure(item: data)

		return cell
	}

	func view(of kind: String, at indexPath: IndexPath, view: UICollectionView) -> UICollectionReusableView? {
		let view: TitleHeader = view.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)

		if let section = fetchedDataSource.controller.sections?[indexPath.section] {
			view.titleLabel.text = section.name
		}

		return view
	}
}
