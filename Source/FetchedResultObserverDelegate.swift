//
//  FetchedResultsObserverDelegate.swift
//  FetchedDataSource
//
//  Created by David Jennes on 02/10/2018.
//

import CoreData

public protocol FetchedResultsObserverDelegate: AnyObject {
	/// Called when the controller will trigger content changes.
	func willChangeContent()

	/// Called when the controller has finished with content changes.
	func didChangeContent()
}

public extension FetchedResultsObserverDelegate {
	func willChangeContent() {
	}

	func didChangeContent() {
	}
}
