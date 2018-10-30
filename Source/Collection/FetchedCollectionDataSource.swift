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

public final class FetchedCollectionDataSource<DelegateType: FetchedCollectionDataSourceDelegate>: __FetchedDataSource<DelegateType.ResultType, UICollectionViewCell> {

	/// toggle animations on or off. If set to false, will use `reloadData()` internally
	public var animateChanges: Bool {
		get {
			return observer.animateChanges
		}
		set {
			observer.animateChanges = newValue
		}
	}

	private let dataSource: CollectionDataSource<DelegateType>
	private let observer: CollectionFetchedResultsObserver<DelegateType.ResultType>

	public init(controller: NSFetchedResultsController<DelegateType.ResultType>, view: UICollectionView, delegate: DelegateType, animateChanges: Bool = true) {
		dataSource = CollectionDataSource(controller: controller, view: view, delegate: delegate)
		observer = CollectionFetchedResultsObserver(controller: controller, view: view, delegate: delegate)
		super.init(controller: controller)

		dataSource.finishSetup()

		observer.animateChanges = animateChanges
		observer.finishSetup()
	}

	public override func object(for cell: UICollectionViewCell) -> DelegateType.ResultType? {
		return dataSource.object(for: cell)
	}
}
