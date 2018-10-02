//
//  FetchedTableDataSource.swift
//  FetchedDataSource
//
//  Created by David Jennes on 27/12/16.
//  Copyright © 2016. All rights reserved.
//

import CoreData
import UIKit

public protocol FetchedTableDataSourceDelegate: TableDataSourceDelegate & FetchedResultsObserverDelegate {
}

public final class FetchedTableDataSource<DelegateType: FetchedTableDataSourceDelegate>: __FetchedDataSource<DelegateType.ResultType, UITableViewCell> {
	/// Dictionary to configure the different animations to be applied by each change type.
	public var animations: [NSFetchedResultsChangeType: UITableView.RowAnimation] {
		get {
			return observer.animations
		}
		set {
			observer.animations = animations
		}
	}

	/// toggle animations on or off. If set to false, will use `reloadData()` internally
	public var animateChanges: Bool {
		get {
			return observer.animateChanges
		}
		set {
			observer.animateChanges = animateChanges
		}
	}

	private let dataSource: TableDataSource<DelegateType>
	private let observer: TableFetchedResultsObserver<DelegateType.ResultType>

	public init(controller: NSFetchedResultsController<DelegateType.ResultType>, view: UITableView, delegate: DelegateType, animateChanges: Bool = true) {
		dataSource = TableDataSource(controller: controller, view: view, delegate: delegate)
		observer = TableFetchedResultsObserver(controller: controller, view: view, delegate: delegate)
		super.init(controller: controller)

		dataSource.finishSetup()
		observer.finishSetup()
	}

	public override func object(for cell: UITableViewCell) -> DelegateType.ResultType? {
		return dataSource.object(for: cell)
	}
}
