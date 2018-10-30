//
//  TableFetchedResultsObserver.swift
//  FetchedDataSource
//
//  Created by David Jennes on 02/10/2018.
//

import CoreData
import UIKit

final class TableFetchedResultsObserver<ResultType: NSFetchRequestResult>: FetchedResultsObserver<ResultType> {
	var animations: [NSFetchedResultsChangeType: UITableView.RowAnimation] = [:]
	private weak var view: UITableView?

	init(controller: NSFetchedResultsController<ResultType>, view: UITableView, delegate: FetchedResultsObserverDelegate, animateChanges: Bool) {
		self.view = view
		super.init(controller: controller, delegate: delegate, animateChanges: animateChanges)
	}

	// MARK: - NSFetchedResultsControllerDelegate

	override func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		super.controllerWillChangeContent(controller)
		if shouldAnimateChanges {
			view?.beginUpdates()
		}
	}

	override func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		super.controller(controller, didChange: anObject, at: indexPath, for: type, newIndexPath: newIndexPath)

		guard var actualType = NSFetchedResultsChangeType(rawValue: type.rawValue) else {
			// This fix is for a bug where iOS passes 0 for NSFetchedResultsChangeType, but this is not a valid enum case.
			// Swift will then always execute the first case of the switch causing strange behaviour.
			// https://forums.developer.apple.com/thread/12184#31850
			return
		}

		// This whole dance is a workaround for a nasty bug introduced in XCode 7 targeted at iOS 8 devices
		// http://stackoverflow.com/questions/31383760/ios-9-attempt-to-delete-and-reload-the-same-index-path/31384014#31384014
		// https://forums.developer.apple.com/message/9998#9998
		// https://forums.developer.apple.com/message/31849#31849
		if #available(iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
			// I don't know if iOS 10 even attempted to fix this mess...
			if case .update = actualType, indexPath != nil, newIndexPath != nil {
				actualType = .move
			}
		}

		switch actualType {
		case .insert:
			if let newIndexPath = newIndexPath {
				changes.addObjectChange(type: actualType, path: newIndexPath)
			}
		case .delete:
			if let indexPath = indexPath {
				changes.addObjectChange(type: actualType, path: indexPath)
			}
		case .update:
			// avoid crash when updating non-visible rows:
			// http://stackoverflow.com/questions/11432556/nsrangeexception-exception-in-nsfetchedresultschangeupdate-event-of-nsfetchedres
			if let indexPath = indexPath, let _ = view?.indexPathsForVisibleRows?.index(of: indexPath) {
				changes.addObjectChange(type: actualType, path: indexPath)
			}
		case .move:
			if let indexPath = indexPath, let newIndexPath = newIndexPath {
				changes.addObjectMove(from: indexPath, to: newIndexPath)
			}
			break
		}
	}

	override func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
		super.controller(controller, didChange: sectionInfo, atSectionIndex: sectionIndex, for: type)
		changes.addSectionChange(type: type, index: sectionIndex)
	}

	override func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		FetchedDataSourceSwiftTryCatch.try({
			if self.shouldAnimateChanges {
				self.apply(changes: self.changes)
				self.view?.endUpdates()
			} else {
				self.view?.reloadData()
			}
		}, catch: { [weak self] exception in
			self?.view?.reloadData()
			}, finally: {
				super.controllerDidChangeContent(controller)
				self.changes = FetchedChanges()
		})
	}

	// MARK: - Helper methods

	private var shouldAnimateChanges: Bool {
		return isVisible && view?.window != nil && animateChanges
	}

	private func apply(changes: FetchedChanges) {
		view?.deleteSections(changes.deletedSections, with: animations[.delete] ?? .automatic)
		view?.insertSections(changes.insertedSections, with: animations[.insert] ?? .automatic)
		view?.reloadSections(changes.updatedSections, with: animations[.update] ?? .automatic)
		view?.deleteRows(at: Array(changes.deletedObjects), with: animations[.delete] ?? .automatic)
		view?.insertRows(at: Array(changes.insertedObjects), with: animations[.insert] ?? .automatic)
		view?.reloadRows(at: Array(changes.updatedObjects), with: animations[.update] ?? .automatic)
		for move in changes.movedObjects {
			view?.deleteRows(at: [move.from], with: animations[.delete] ?? .automatic)
			view?.insertRows(at: [move.to], with: animations[.insert] ?? .automatic)
		}
	}
}
