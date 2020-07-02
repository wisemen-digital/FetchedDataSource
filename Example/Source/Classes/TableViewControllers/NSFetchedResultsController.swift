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
	var fetchedDataSource: FetchedTableDataSource<Item>!

	override func viewDidLoad() {
		super.viewDidLoad()

		fetchedDataSource = FetchedTableDataSource(controller: Item.nsfrc, view: tableView, delegate: self)
	}
}

extension NSFetchedResultsControllerTableViewController: FetchedTableDataSourceDelegate {
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(for: indexPath) as TableCell

		if let item = fetchedDataSource.object(at: indexPath) {
			cell.configure(item: item)
		}

		return cell
	}
}

class NSFetchedResultsControllerCollectionViewController: UICollectionViewController {
	var fetchedDataSource: FetchedCollectionDataSource<Item>!

	override func viewDidLoad() {
		super.viewDidLoad()

		fetchedDataSource = FetchedCollectionDataSource(controller: Item.nsfrc, view: collectionView, delegate: self)
	}
}

extension NSFetchedResultsControllerCollectionViewController: FetchedCollectionDataSourceDelegate {
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(for: indexPath) as CollectionCell

		if let item = fetchedDataSource.object(at: indexPath) {
			cell.configure(item: item)
		}

		return cell
	}

	override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let view: TitleHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)

		if let section = fetchedDataSource.controller.sections?[indexPath.section] {
			view.titleLabel.text = section.name
		}

		return view
	}
}
