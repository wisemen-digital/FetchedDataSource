//
//  FetchedCollectionDataSource.swift
//  FetchedDataSource
//
//  Created by David Jennes on 27/12/16.
//  Copyright © 2016. All rights reserved.
//

import CoreData
import UIKit

class FetchedCollectionDataSource<FetchResult: NSFetchRequestResult, DelegateType: FetchedDataSourceDelegate where DelegateType.DataType == FetchResult, DelegateType.ViewType == UICollectionView, DelegateType.CellType == UICollectionViewCell>: FetchedDataSource<FetchResult, DelegateType>, UICollectionViewDataSource {

	fileprivate var shouldReloadView = false
	
	override init(view: DelegateType.ViewType, controller: NSFetchedResultsController<FetchResult>, delegate: DelegateType) {
		super.init(view: view, controller: controller, delegate: delegate)

		defer {
			view.dataSource = self
		}
	}

	public override func data(for cell: DelegateType.CellType) -> FetchResult? {
		guard let path = view?.indexPath(for: cell) else { return nil }
		return controller.object(at: path)
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

		let data = controller.object(at: indexPath)
		let cell = delegate.cell(for: indexPath, data: data, view: collectionView)

		return cell
	}

	// MARK: - NSFetchedResultsControllerDelegate

	public override func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
	}

	public override func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
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
		guard !shouldReloadView else { return }
		changes.addSectionChange(type: type, index: sectionIndex)
	}

	public override func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		view?.collectionViewLayout.invalidateLayout()

		if shouldReloadView {
			view?.reloadData()
		} else {
			view?.performBatchUpdates({ [weak self] in
				guard let strongSelf = self else { return }

				strongSelf.view?.deleteSections(strongSelf.changes.deletedSections)
				strongSelf.view?.insertSections(strongSelf.changes.insertedSections)
				strongSelf.view?.reloadSections(strongSelf.changes.updatedSections)
				strongSelf.view?.deleteItems(at: Array(strongSelf.changes.deletedObjects))
				strongSelf.view?.insertItems(at: Array(strongSelf.changes.insertedObjects))
				strongSelf.view?.reloadItems(at: Array(strongSelf.changes.updatedObjects))
				for move in strongSelf.changes.movedObjects {
					strongSelf.view?.moveItem(at: move.from, to: move.to)
				}
			}, completion: nil)
		}

		changes = FetchedChanges()
		shouldReloadView = false
	}
}
