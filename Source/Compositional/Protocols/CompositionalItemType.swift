//
//  CompositionalItemType.swift
//  FetchedDataSource
//
//  Created by Jonathan Provo on 09/02/2022.
//

import CoreData

/// Items in the compositional datasource need to conform to this protocol.
/// The protocol ensures that datasource items are constructed with the results from the backing `NSFetchedResultsController`.
public protocol CompositionalItemType: Hashable {
	init(managedObject: NSManagedObject)
}
