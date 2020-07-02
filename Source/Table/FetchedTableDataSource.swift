//
//  FetchedTableDataSource.swift
//  FetchedDataSource
//
//  Created by David Jennes on 27/12/16.
//  Copyright © 2016. All rights reserved.
//

import CoreData
import UIKit

public protocol FetchedTableDataSourceDelegate: UITableViewDataSource & FetchedResultsObserverDelegate & TableDataSourceDelegate {
}

public final class FetchedTableDataSource<ResultType: NSFetchRequestResult>: __FetchedDataSource<ResultType, UITableViewCell> {
	/// Dictionary to configure the different animations to be applied by each change type.
	public var animations: [NSFetchedResultsChangeType: UITableView.RowAnimation] {
		get {
			return observer.animations
		}
		set {
			observer.animations = newValue
		}
	}

	/// toggle animations on or off. If set to false, will use `reloadData()` internally
	public var animateChanges: Bool {
		get {
			return observer.animateChanges
		}
		set {
			observer.animateChanges = newValue
		}
	}

	private let dataSource: TableDataSource<ResultType>
	private let observer: TableFetchedResultsObserver<ResultType>

	public init(controller: NSFetchedResultsController<ResultType>, view: UITableView, delegate: FetchedTableDataSourceDelegate, animateChanges: Bool = true) {
		dataSource = TableDataSource(controller: controller, view: view, delegate: delegate)
		observer = TableFetchedResultsObserver(controller: controller, view: view, delegate: delegate, animateChanges: animateChanges)
		super.init(controller: controller)

		dataSource.finishSetup()
		observer.finishSetup()
	}

	public override func object(for cell: UITableViewCell) -> ResultType? {
		return dataSource.object(for: cell)
	}
}
