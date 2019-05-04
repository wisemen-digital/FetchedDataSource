//
//  FetchedCollectionDataSource.swift
//  FetchedDataSource
//
//  Created by David Jennes on 27/12/16.
//  Copyright © 2016. All rights reserved.
//

import CoreData
import UIKit

public protocol FetchedCollectionDataSourceDelegate: CollectionDataSourceDelegate & FetchedResultsObserverDelegate {
}

public final class FetchedCollectionDataSource<ResultType: NSFetchRequestResult>: __FetchedDataSource<ResultType, UICollectionViewCell> {

	/// toggle animations on or off. If set to false, will use `reloadData()` internally
	public var animateChanges: Bool {
		get {
			return observer.animateChanges
		}
		set {
			observer.animateChanges = newValue
		}
	}

	private let dataSource: CollectionDataSource<ResultType>
	private let observer: CollectionFetchedResultsObserver<ResultType>

	public init(controller: NSFetchedResultsController<ResultType>, view: UICollectionView, delegate: FetchedCollectionDataSourceDelegate, animateChanges: Bool = true) {
		dataSource = CollectionDataSource(controller: controller, view: view, delegate: delegate)
		observer = CollectionFetchedResultsObserver(controller: controller, view: view, delegate: delegate, animateChanges: animateChanges)
		super.init(controller: controller)

		dataSource.finishSetup()
		observer.finishSetup()
	}

	public override func object(for cell: UICollectionViewCell) -> ResultType? {
		return dataSource.object(for: cell)
	}
}
