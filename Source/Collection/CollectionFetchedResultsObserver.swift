//
//  CollectionFetchedResultsObserver.swift
//  FetchedDataSource
//
//  Created by David Jennes on 02/10/2018.
//

import CoreData
import UIKit

final class CollectionFetchedResultsObserver<ResultType: NSFetchRequestResult>: FetchedResultsObserver<ResultType> {
	private var shouldReloadView = false
	private weak var view: UICollectionView?

	init(controller: NSFetchedResultsController<ResultType>, view: UICollectionView, delegate: FetchedResultsObserverDelegate, animateChanges: Bool) {
		self.view = view
		super.init(controller: controller, delegate: delegate, animateChanges: animateChanges)
	}

	// MARK: - NSFetchedResultsControllerDelegate

	override func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		if let view = view {
			changes.viewSectionsCache = (0..<view.numberOfSections).map {
				view.numberOfItems(inSection: $0)
			}
		}

		super.controllerWillChangeContent(controller)
	}

	override func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		super.controller(controller, didChange: anObject, at: indexPath, for: type, newIndexPath: newIndexPath)
		guard !shouldReloadView else { return }

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
			// handle bug http://openradar.appspot.com/12954582
			if let newIndexPath = newIndexPath {
				if changes.viewSectionsCache.isEmpty || (newIndexPath.section < changes.viewSectionsCache.count && changes.viewSectionsCache[newIndexPath.section] == 0) {
					shouldReloadView = true
				} else {
					changes.addObjectChange(type: actualType, path: newIndexPath)
				}
			}
		case .delete:
			// handle bug http://openradar.appspot.com/12954582
			if let indexPath = indexPath {
				if (indexPath.section < changes.viewSectionsCache.count && changes.viewSectionsCache[indexPath.section] == 1) {
					shouldReloadView = true
				} else {
					changes.addObjectChange(type: actualType, path: indexPath)
				}
			}
		case .update:
			if let indexPath = indexPath {
				changes.addObjectChange(type: actualType, path: indexPath)
			}
		case .move:
			if let indexPath = indexPath, let newIndexPath = newIndexPath {
				changes.addObjectMove(from: indexPath, to: newIndexPath)
			}
			break
		@unknown default:
			assertionFailure("Unknown object change type in FRC: \(actualType)")
		}
	}

	override func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
		super.controller(controller, didChange: sectionInfo, atSectionIndex: sectionIndex, for: type)
		guard !shouldReloadView else { return }
		changes.addSectionChange(type: type, index: sectionIndex)
	}

	override func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		view?.collectionViewLayout.invalidateLayout()

		if shouldAnimateChanges {
			view?.performBatchUpdates({ [weak self] in
				guard let changes = self?.changes else { return }
				self?.apply(changes: changes)
				}, completion: { [weak self] success in
					self?.finishChanges(reload: !success, controller: controller)
			})
		} else {
			finishChanges(reload: true, controller: controller)
		}
	}

	// MARK: - NSFetchedResultsControllerDelegate

	private var shouldAnimateChanges: Bool {
		return !shouldReloadView && isVisible && view?.window != nil && animateChanges
	}

	private func apply(changes: FetchedChanges) {
		view?.deleteSections(changes.deletedSections)
		view?.insertSections(changes.insertedSections)
		view?.reloadSections(changes.updatedSections)

		// NOTE: because of some bugs, we have to consider moves as delete "from" & insert "to"
		// NOTE: because of some bugs, we have to consider reloads as delete & insert of the same path
		view?.deleteItems(at: Array(changes.deletedObjects))
		view?.deleteItems(at: changes.movedObjects.map { $0.from })
		view?.deleteItems(at: Array(changes.updatedObjects))

		view?.insertItems(at: Array(changes.insertedObjects))
		view?.insertItems(at: changes.movedObjects.map { $0.to })
		view?.insertItems(at: Array(changes.updatedObjects))
	}

	private func finishChanges(reload: Bool, controller: NSFetchedResultsController<NSFetchRequestResult>) {
		if reload {
			view?.reloadData()
		}

		super.controllerDidChangeContent(controller)
		changes = FetchedChanges()
		shouldReloadView = false
	}
}
