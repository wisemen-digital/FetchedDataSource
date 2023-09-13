//
//  FetchedDiffableItem.swift
//  FetchedDataSource
//
//  Created by Jonathan Provo on 14/03/2022.
//

import Foundation

public struct FetchedDiffableItem: Hashable {
	public let sectionIdentifier: String
	let object: NSObject

	public init(item object: NSObject, sectionIdentifier: String) {
		self.object = object
		self.sectionIdentifier = sectionIdentifier
	}

	public func item<T>() -> T? {
		object as? T
	}
}
