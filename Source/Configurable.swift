//
//  FetchedDataSource.swift
//  FetchedDataSource
//
//  Created by David Jennes on 27/12/16.
//  Copyright © 2016. All rights reserved.
//

import Foundation
import Reusable

protocol Configurable {
	associatedtype DataType: Any

	func configure(data: DataType, indexPath: IndexPath)
}
