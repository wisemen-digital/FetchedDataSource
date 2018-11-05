//
//  CollectionDataSource.swift
//  FetchedDataSource
//
//  Created by David Jennes on 01/10/2018.
//

import CoreData
import UIKit

final class CollectionDataSource<DelegateType: CollectionDataSourceDelegate>: DataSource<DelegateType.ResultType>, UICollectionViewDataSource {

	private weak var view: UICollectionView?
	private weak var delegate: DelegateType?

	init(controller: NSFetchedResultsController<DelegateType.ResultType>, view: UICollectionView, delegate: DelegateType) {
		self.view = view
		self.delegate = delegate
		super.init(controller: controller)
	}

	override func finishSetup() {
		super.finishSetup()
		view?.dataSource = self
	}

	func object(for cell: UICollectionViewCell) -> DelegateType.ResultType? {
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
}
