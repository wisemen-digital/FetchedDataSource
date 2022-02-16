//
//  CompositionalFetchedResultsController.swift
//  FetchedDataSource
//
//  Created by Jonathan Provo on 09/02/2022.
//

import CoreData

/// This struct is responsbile for type erasing the generic constraint on a `NSFetchedResultsController` instance.
public struct CompositionalFetchedResultsController {
	// MARK: - Properties

	private let delegateClosure: (NSFetchedResultsControllerDelegate) -> ()
	private let fetchClosure: () throws -> ()
	private let isEqualClosure: (NSFetchedResultsControllerProtocol) -> Bool

	// MARK: - Lifecycle

	public init(controller: NSFetchedResultsControllerProtocol) {
		delegateClosure = { controller.delegate = $0 }
		fetchClosure = { try controller.performFetch() }
		isEqualClosure = { controller.isIdentical(to: $0) }
	}

	// MARK: - Thunks

	func isEqual(to otherController: NSFetchedResultsControllerProtocol) -> Bool {
		isEqualClosure(otherController)
	}

	func performFetch() throws {
		try fetchClosure()
	}

	func set(delegate: NSFetchedResultsControllerDelegate) {
		delegateClosure(delegate)
	}
}
