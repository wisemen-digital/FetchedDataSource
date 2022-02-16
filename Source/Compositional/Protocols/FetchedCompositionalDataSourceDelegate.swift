//
//  FetchedCompositionalDataSourceDelegate.swift
//  FetchedDataSource
//
//  Created by Jonathan Provo on 23/02/2022.
//

import CoreData

@available(iOS 14.0, *)
// sourcery: AutoMockable
public protocol FetchedCompositionalDataSourceDelegate: FetchedResultsObserverDelegate {
	/// Should only be used for testing purposes.
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference)
}

@available(iOS 14.0, *)
public extension FetchedCompositionalDataSourceDelegate {
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
	}
}
