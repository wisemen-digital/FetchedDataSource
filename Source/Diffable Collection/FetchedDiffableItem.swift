//
//  FetchedDiffableItem.swift
//  FetchedDataSource
//
//  Created by Jonathan Provo on 14/03/2022.
//

import CoreData

public struct FetchedDiffableItem: Hashable {
	// MARK: - Properties

	private let object: NSManagedObject?

	// MARK: - Lifecycle

	public init(item: NSManagedObject?) {
		object = item
	}

	// MARK: - Item

	public func item<T>() -> T? {
		object as? T
	}
}
