//
//  FetchedCollectionDiffableDataSourceDelegate.swift
//  FetchedDataSource
//
//  Created by Jonathan Provo on 14/03/2022.
//

import Foundation

@available(iOS 13.0, *)
public protocol FetchedCollectionDiffableDataSourceDelegate: FetchedResultsObserverDelegate {
	func contentChangeWillBeApplied(snapshot: inout NSDiffableDataSourceSnapshot<FetchedDiffableSection, FetchedDiffableItem>)
}

@available(iOS 13.0, *)
public extension FetchedCollectionDiffableDataSourceDelegate {
	func contentChangeWillBeApplied(snapshot: inout NSDiffableDataSourceSnapshot<FetchedDiffableSection, FetchedDiffableItem>) {
	}
}
