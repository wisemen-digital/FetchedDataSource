//
//  NSFetchedResultsControllerProtocol.swift
//  ExampleTests
//
//  Created by Jonathan Provo on 21/02/2022.
//  Copyright © 2022 Appwise. All rights reserved.
//

import CoreData

// sourcery: AutoMockable
public protocol NSFetchedResultsControllerProtocol: AnyObject {
	var delegate: NSFetchedResultsControllerDelegate? { get set }
	
	func isIdentical(to object: NSFetchedResultsControllerProtocol) -> Bool
	func performFetch() throws
}

public extension NSFetchedResultsControllerProtocol {
	func isIdentical(to object: NSFetchedResultsControllerProtocol) -> Bool {
		self === object
	}
}

// sourcery: associatedType = "ResultType: NSFetchRequestResult"
extension NSFetchedResultsController: NSFetchedResultsControllerProtocol {
}
