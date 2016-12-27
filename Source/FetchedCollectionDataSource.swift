//
//  FetchedCollectionDataSource.swift
//  FetchedDataSource
//
//  Created by David Jennes on 27/12/16.
//  Copyright © 2016. All rights reserved.
//

import CoreData
import UIKit

class FetchedCollectionDataSource<FetchResult: NSFetchRequestResult, DelegateType: FetchedDataSourceDelegate where DelegateType.DataType == FetchResult, DelegateType.ViewType == UICollectionView, DelegateType.CellType == UICollectionViewCell> : FetchedDataSource<FetchResult, DelegateType>, UICollectionViewDataSource {
	
	override init(view: DelegateType.ViewType, controller: NSFetchedResultsController<FetchResult>, delegate: DelegateType) {
		super.init(view: view, controller: controller, delegate: delegate)

		defer {
			view.dataSource = self
		}
	}

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return controller.sections?.count ?? 0
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return controller.sections?[section].numberOfObjects ?? 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)

		let data = controller.object(at: indexPath)

		return cell
	}
}
