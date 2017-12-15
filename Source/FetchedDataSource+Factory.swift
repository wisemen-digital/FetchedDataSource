//
//  FetchedDataSource.swift
//  FetchedDataSource
//
//  Created by David Jennes on 27/12/16.
//  Copyright © 2016. All rights reserved.
//

import CoreData
import UIKit

public extension FetchedDataSource where
	DelegateType: FetchedTableDataSourceDelegate {

	static func `for`(tableView: DelegateType.ViewType, controller: ControllerType, delegate: DelegateType, animateChanges: Bool = true) -> FetchedDataSource<ResultType, DelegateType> {
		return FetchedTableDataSource(view: tableView, controller: controller, delegate: delegate, animateChanges: animateChanges)
	}
}

public extension FetchedDataSource where
	DelegateType: FetchedCollectionDataSourceDelegate {

	static func `for`(collectionView: DelegateType.ViewType, controller: ControllerType, delegate: DelegateType, animateChanges: Bool = true) -> FetchedDataSource<ResultType, DelegateType> {
		return FetchedCollectionDataSource(view: collectionView, controller: controller, delegate: delegate, animateChanges: animateChanges)
	}
}
