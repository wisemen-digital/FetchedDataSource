//
//  FetchedDataSource.swift
//  FetchedDataSource
//
//  Created by David Jennes on 27/12/16.
//  Copyright © 2016. All rights reserved.
//

import CoreData
import UIKit

public extension FetchedDataSource where DelegateType: FetchedDataSourceDelegate, FetchResult == DelegateType.DataType, DelegateType.ViewType == UITableView, DelegateType.CellType == UITableViewCell {
	static func `for`(tableView: DelegateType.ViewType, controller: NSFetchedResultsController<FetchResult>, delegate: DelegateType) -> FetchedDataSource<FetchResult, DelegateType> {
		return FetchedTableDataSource<FetchResult, DelegateType>(view: tableView, controller: controller, delegate: delegate)
	}
}

public extension FetchedDataSource where DelegateType: FetchedDataSourceDelegate, FetchResult == DelegateType.DataType, DelegateType.ViewType == UICollectionView, DelegateType.CellType == UICollectionViewCell {
	static func `for`(collectionView: DelegateType.ViewType, controller: NSFetchedResultsController<FetchResult>, delegate: DelegateType) -> FetchedDataSource<FetchResult, DelegateType> {
		return FetchedCollectionDataSource<FetchResult, DelegateType>(view: collectionView, controller: controller, delegate: delegate)
	}
}
