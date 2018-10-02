//
//  FetchedDataSource.swift
//  FetchedDataSource
//
//  Created by David Jennes on 27/12/16.
//  Copyright © 2016. All rights reserved.
//

@_exported import CoreData
import UIKit

public enum FetchedDataSource {
	public static func `for`<T: FetchedTableDataSourceDelegate>(tableView: UITableView, controller: NSFetchedResultsController<T.ResultType>, delegate: T, animateChanges: Bool = true) -> FetchedTableDataSource<T> {
		return FetchedTableDataSource(controller: controller, view: tableView, delegate: delegate, animateChanges: animateChanges)
	}

	public static func `for`<T: FetchedCollectionDataSourceDelegate>(collectionView: UICollectionView, controller: NSFetchedResultsController<T.ResultType>, delegate: T, animateChanges: Bool = true) -> FetchedCollectionDataSource<T> {
		return FetchedCollectionDataSource(controller: controller, view: collectionView, delegate: delegate, animateChanges: animateChanges)
	}
}
