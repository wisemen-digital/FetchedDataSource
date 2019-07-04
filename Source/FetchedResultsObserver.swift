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
	var animateChanges: Bool
	private(set) var isVisible = true

	private var monitor: LifecycleBehaviorViewController?

	init(controller: NSFetchedResultsController<ResultType>, delegate: FetchedResultsObserverDelegate, animateChanges: Bool) {
		self.controller = controller
		self.delegate = delegate
		self.animateChanges = animateChanges
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
			assertionFailure("Delegate must be a UIViewController, instead got \(delegate)")
		} else {
			// Delegate is nil, not sure if we should crash or not
		}
		self.monitor = monitor
	}

	deinit {
		// dealocate monitor if needed
		if let monitor = monitor, monitor.parent != nil {
			monitor.willMove(toParent: nil)
			monitor.removeFromParent()
			monitor.view.removeFromSuperview()
		}
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
