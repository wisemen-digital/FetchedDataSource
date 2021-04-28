//
//  CollectionDataSource.swift
//  FetchedDataSource
//
//  Created by David Jennes on 01/10/2018.
//

import CoreData
import UIKit

final class CollectionDataSource<ResultType: NSFetchRequestResult>: DataSource<ResultType>, UICollectionViewDataSource {

	private weak var view: UICollectionView?
	private weak var delegate: UICollectionViewDataSource?

	init(controller: NSFetchedResultsController<ResultType>, view: UICollectionView, delegate: UICollectionViewDataSource) {
		self.view = view
		self.delegate = delegate
		super.init(controller: controller)
	}

	override func finishSetup() {
		super.finishSetup()
		view?.dataSource = self
	}

	func object(for cell: UICollectionViewCell) -> ResultType? {
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

		return delegate.collectionView(collectionView, cellForItemAt: indexPath)
	}

	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		guard let delegate = delegate else { fatalError("Delegate cannot be nil") }

		return delegate.collectionView?(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath) ?? UICollectionReusableView()
	}

	func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
		return delegate?.collectionView?(collectionView, canMoveItemAt: indexPath) ?? false
	}

	func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		delegate?.collectionView?(collectionView, moveItemAt: sourceIndexPath, to: destinationIndexPath)
	}

	@available(iOS 9.0, *)
	func indexTitles(for collectionView: UICollectionView) -> [String]? {
		return delegate?.indexTitles?(for: collectionView)
	}

	@available(iOS 9.0, *)
	func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath {
		delegate?.collectionView?(collectionView, indexPathForIndexTitle: title, at: index) ?? IndexPath()
	}
}
