//
//  CompositionalSectionType.swift
//  FetchedDataSource
//
//  Created by Jonathan Provo on 09/02/2022.
//

import Foundation

/// Sections in the compositional datasource need to conform to this protocol.
/// The protocol ensures that:
/// - in case of static sections, the order is maintained by means of the `index` property
/// - in case of dynamic sections, the sections are constructed with the results from the backing `NSFetchedResultsController`
public protocol CompositionalSectionType: Hashable {
	var index: Int { get }
	
	init?(identifier: String)
}

public extension CompositionalSectionType {
	var index: Int {
		fatalError("No implementation provided.")
	}

	init?(identifier: String) {
		fatalError("No implementation provided.")
	}
}
