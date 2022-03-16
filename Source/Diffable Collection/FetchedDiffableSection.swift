//
//  FetchedDiffableSection.swift
//  FetchedDataSource
//
//  Created by Jonathan Provo on 14/03/2022.
//

import Foundation

public struct FetchedDiffableSection: Hashable {
	// MARK: - Properties

	public let identifier: String

	// MARK: - Lifecycle

	public init(identifier: String) {
		self.identifier = identifier
	}

	// MARK: - Hashable

	public func hash(into hasher: inout Hasher) {
		hasher.combine(identifier)
	}

	// MARK: - Equatable

	public static func == (lhs: FetchedDiffableSection, rhs: FetchedDiffableSection) -> Bool {
		lhs.identifier == rhs.identifier
	}
}
