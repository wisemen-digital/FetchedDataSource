//
//  DataSource.swift
//  FetchedDataSource
//
//  Created by David Jennes on 01/10/2018.
//

import CoreData
import UIKit

class DataSource<ResultType: NSFetchRequestResult>: NSObject {
	let controller: NSFetchedResultsController<ResultType>

	init(controller: NSFetchedResultsController<ResultType>) {
		self.controller = controller
		super.init()
	}

	func finishSetup() {
		do {
			try controller.performFetch()
		} catch let error {
			assertionFailure("Error performing controller fetch: \(error)")
		}
	}

	// MARK: - Helper methods

	func contains(indexPath: IndexPath) -> Bool {
		return indexPath.section < (controller.sections?.count ?? 0) &&
			indexPath.row < (controller.sections?[indexPath.section].numberOfObjects ?? 0)
	}

	func object(at indexPath: IndexPath) -> ResultType {
		precondition(contains(indexPath: indexPath), "The index path is out of bounds for the controller: \(indexPath)")
		return controller.object(at: indexPath)
	}
}
