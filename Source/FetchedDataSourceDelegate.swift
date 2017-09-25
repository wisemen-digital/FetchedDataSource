//
//  FetchedDataSource.swift
//  FetchedDataSource
//
//  Created by David Jennes on 27/12/16.
//  Copyright © 2016. All rights reserved.
//

import CoreData
import UIKit

public protocol FetchedDataSourceDelegate: class {
	associatedtype DataType: NSFetchRequestResult
	associatedtype ViewType: UIView
	associatedtype CellType: UIView
	
	func willChangeContent()
	func didChangeContent()
	func cell(for indexPath: IndexPath, data: DataType, view: ViewType) -> CellType
	func canMoveItem(at indexPath: IndexPath, view: ViewType) -> Bool
	func moveItem(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath, view: ViewType)
}

public extension FetchedDataSourceDelegate {
	func willChangeContent() {
	}
	
	func didChangeContent() {
	}

	func canMoveItem(at indexPath: IndexPath, view: ViewType) -> Bool {
		return false
	}

	func moveItem(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath, view: ViewType) {
	}
}

public protocol FetchedTableDataSourceDelegate: FetchedDataSourceDelegate where ViewType == UITableView, CellType == UITableViewCell {
	func titleForHeader(in section: Int, view: ViewType, default: String?) -> String?
	func titleForFooter(in section: Int, view: ViewType) -> String?

	func canEditRow(at indexPath: IndexPath, view: ViewType) -> Bool
	func commit(edit: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath, view: ViewType)
}

public extension FetchedTableDataSourceDelegate {
	func titleForHeader(in section: Int, view: ViewType, default: String?) -> String? {
		return `default`
	}

	func titleForFooter(in section: Int, view: ViewType) -> String? {
		return nil
	}

	func canEditRow(at indexPath: IndexPath, view: ViewType) -> Bool {
		return true
	}

	func commit(edit: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath, view: ViewType) {
	}
}

public protocol FetchedCollectionDataSourceDelegate: FetchedDataSourceDelegate where ViewType == UICollectionView, CellType == UICollectionViewCell {
	func view(of kind: String, at indexPath: IndexPath, view: ViewType) -> UICollectionReusableView?
}

public extension FetchedCollectionDataSourceDelegate {
	func view(of kind: String, at indexPath: IndexPath, view: ViewType) -> UICollectionReusableView? {
		return nil
	}
}
