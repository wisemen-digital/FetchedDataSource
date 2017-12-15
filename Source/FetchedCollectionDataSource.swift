//
//  FetchedCollectionDataSource.swift
//  FetchedDataSource
//
//  Created by David Jennes on 27/12/16.
//  Copyright © 2016. All rights reserved.
//

import CoreData
import UIKit

class FetchedCollectionDataSource<ResultType: NSFetchRequestResult, DelegateType: FetchedCollectionDataSourceDelegate>: FetchedDataSource<ResultType, DelegateType>, UICollectionViewDataSource {

	fileprivate var shouldReloadView = false
	
	override init(view: DelegateType.ViewType, controller: ControllerType, delegate: DelegateType, animateChanges: Bool = true) {
		super.init(view: view, controller: controller, delegate: delegate, animateChanges: animateChanges)

		defer {
			view.dataSource = self
		}
	}

	public override func object(for cell: DelegateType.CellType) -> DelegateType.DataType? {
		guard let path = view?.indexPath(for: cell) else { return nil }
		return object(at: path)
	}

	// MARK: - UICollectionViewDataSource

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return controller.sections?.count ?? 0
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return controller.sections?[section].numberOfObjects ?? 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let delegate = delegate else { fatalError("Delegate cannot be nil") }

		let data = object(at: indexPath)
		let cell = delegate.cell(for: indexPath, data: data, view: collectionView)

		return cell
	}

	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		guard let delegate = delegate else { fatalError("Delegate cannot be nil") }

		return delegate.view(of: kind, at: indexPath, view: collectionView) ?? UICollectionReusableView()
	}

	func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
		return delegate?.canMoveItem(at: indexPath, view: collectionView) ?? false
	}

	func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		delegate?.moveItem(at: sourceIndexPath, to: destinationIndexPath, view: collectionView)
	}

	// MARK: - NSFetchedResultsControllerDelegate

	public override func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		super.controllerWillChangeContent(controller)
	}

	public override func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		super.controller(controller, didChange: anObject, at: indexPath, for: type, newIndexPath: newIndexPath)
		guard !shouldReloadView, let view = view else { return }

		switch type {
		case .insert:
			// handle bug http://openradar.appspot.com/12954582
			if let newIndexPath = newIndexPath {
				if view.numberOfSections == 0 || view.numberOfItems(inSection: newIndexPath.section) == 0 {
					shouldReloadView = true
				} else {
					changes.addObjectChange(type: type, path: newIndexPath)
				}
			}
		case .delete:
			// handle bug http://openradar.appspot.com/12954582
			if let indexPath = indexPath {
				if view.numberOfItems(inSection: indexPath.section) == 1 {
					shouldReloadView = true
				} else {
					changes.addObjectChange(type: type, path: indexPath)
				}
			}
		case .update:
			if let indexPath = indexPath {
				changes.addObjectChange(type: type, path: indexPath)
			}
		case .move:
			if let indexPath = indexPath, let newIndexPath = newIndexPath {
				changes.addObjectMove(from: indexPath, to: newIndexPath)
			}
			break
		}
	}

	public override func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
		super.controller(controller, didChange: sectionInfo, atSectionIndex: sectionIndex, for: type)
		guard !shouldReloadView else { return }
		changes.addSectionChange(type: type, index: sectionIndex)
	}

	public override func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
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
