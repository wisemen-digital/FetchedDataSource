//
//  CompositionalFetchedResultsControllerTests.swift
//  ExampleTests
//
//  Created by Jonathan Provo on 21/02/2022.
//  Copyright © 2022 Appwise. All rights reserved.
//

import SwiftyMocky
import XCTest

@testable import FetchedDataSource

class CompositionalFetchedResultsControllerTests: XCTestCase {
	// MARK: - Properties

	private var controller: NSFetchedResultsControllerProtocolMock!
	private var sut: CompositionalFetchedResultsController!

	// MARK: - Set up & tear down

	override func setUp() {
		super.setUp()

		Matcher.default.register(NSFetchedResultsControllerDelegate?.self) { $0 === $1 }
		Matcher.default.register(NSFetchedResultsControllerProtocol.self) { $0 === $1 }

		controller = .init()
		sut = .init(controller: controller)
	}

	override func tearDown() {
		super.tearDown()
	}

	// MARK: - Tests

	func testShouldPerformDelegateClosure() {
		sut.set(delegate: self)
		controller.verify(.delegate(set: .value(self)), count: 1)
	}

	func testShouldPerformEqualClosure() {
		controller.given(.isIdentical(to: .value(controller), willReturn: true))
		controller.given(.isIdentical(to: .any, willReturn: false))
		XCTAssertTrue(sut.isEqual(to: controller))
		controller.verify(.isIdentical(to: .value(controller)), count: 1)
	}

	func testShouldPerformFetchClosure() {
		do {
			try sut.performFetch()
			controller.verify(.performFetch(), count: 1)
		} catch {
			XCTFail()
		}
	}
}

extension CompositionalFetchedResultsControllerTests: NSFetchedResultsControllerDelegate {
}
