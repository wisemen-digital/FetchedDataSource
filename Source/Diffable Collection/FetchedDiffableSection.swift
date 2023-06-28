//
//  FetchedDiffableSection.swift
//  FetchedDataSource
//
//  Created by Jonathan Provo on 14/03/2022.
//

import Foundation

public struct FetchedDiffableSection: Hashable {
	public let identifier: String
	
	public init(identifier: String) {
		self.identifier = identifier
	}
}
