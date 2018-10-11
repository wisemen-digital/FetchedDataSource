//
//  FRCObserverObserver.swift
//  FetchedDataSource
//
//  Created by David Jennes on 02/10/2018.
//

import CoreData

class FetchedResultsObserver<ResultType: NSFetchRequestResult>: NSObject, NSFetchedResultsControllerDelegate {
	let controller: NSFetchedResultsController<ResultType>
	weak var delegate: FetchedResultsObserverDelegate?
	lazy var changes = FetchedChanges()
	var animateChanges = true
	var isVisible = true

	private var monitor: LifecycleBehaviorViewController?

	init(controller: NSFetchedResultsController<ResultType>, delegate: FetchedResultsObserverDelegate) {
		self.controller = controller
		self.delegate = delegate
		super.init()
	}

	func finishSetup() {
		controller.delegate = self

		// monitor visibility
		let monitor = LifecycleBehaviorViewController { [weak self] visible in
			self?.isVisible = visible
		}
		if let vc = delegate as? UIViewController {
			vc.addChild(monitor)
			vc.view.addSubview(monitor.view)
			monitor.didMove(toParent: vc)
		} else if let delegate = delegate {
			fatalError("Delegate must be a UIViewController, instead got \(delegate)")
		} else {
			// Delegate is nil, not sure if we should crash or not
		}
		self.monitor = monitor
	}

	// MARK: - Empty NSFetchedResultsControllerDelegate methods
	// Needed for correct method dispatch

	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		delegate?.willChangeContent()
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		delegate?.didChangeContent()
	}
}
