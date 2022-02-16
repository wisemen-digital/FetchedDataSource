//
//  StaticFetchedCompositionalDataSourceTests.swift
//  ExampleTests
//
//  Created by Jonathan Provo on 21/02/2022.
//  Copyright © 2022 Appwise. All rights reserved.
//

import SwiftyMocky
import XCTest

@testable import FetchedDataSource

class StaticFetchedCompositionalDataSourceTests: XCTestCase {
	// MARK: - Properties

	private var database: DatabaseMock!
	private var collectionView: UICollectionView!
	private var controllerOne: NSFetchedResultsController<NSFetchRequestResult>!
	private var controllerTwo: NSFetchedResultsController<NSFetchRequestResult>!
	private var dataSource: CompositionalStaticDataSource!
	private var delegate: FetchedCompositionalDataSourceDelegateMock!
	private var sut: FetchedCompositionalDataSource<CompositionalStaticSection, CompositionalItem>!

	// MARK: - Set up & tear down

	override func setUp() {
		super.setUp()
		database = .init()
		collectionView = .init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
		controllerOne = createFetchedResultsController(entityName: itemEntityName)
		controllerTwo = createFetchedResultsController(entityName: otherItemEntityName)
		dataSource = CompositionalStaticDataSource.createDataSource(collectionView: collectionView)
		delegate = .init()
		sut = .static(controllers: [
			.sectionOne: .init(controller: controllerOne),
			.sectionTwo: .init(controller: controllerTwo)
		], dataSource: dataSource, delegate: delegate)
	}

	override func tearDown() {
		super.tearDown()
	}

	// MARK: - Tests

	func testSections() {
		let snapshot = dataSource.snapshot()
		XCTAssertEqual(snapshot.sectionIdentifiers.count, 2)
		XCTAssertEqual(snapshot.sectionIdentifiers[0], .sectionOne)
		XCTAssertEqual(snapshot.sectionIdentifiers[1], .sectionTwo)
	}

	func testShouldCallWillChange() {
		sut.controllerWillChangeContent(controllerOne)
		sut.controllerWillChangeContent(controllerTwo)

		delegate.verify(.willChangeContent(), count: .exactly(2))
	}

	func testShouldCallDidChange() {
		sut.controllerDidChangeContent(controllerOne)
		sut.controllerDidChangeContent(controllerTwo)

		delegate.verify(.didChangeContent(), count: .exactly(2))
	}

	func testCreation() {
		let objects = createItems(count: 2)
		let otherObjects = createOtherItems(count: 1)
		database.save()

		delegate.verify(.controller(.value(controllerOne), didChangeContentWith: .matching({ snapshotReference in
			guard snapshotReference.sectionIdentifiers.count == 1 else { return false }
			guard snapshotReference.itemIdentifiers.count == 2 else { return false }
			guard snapshotReference.itemIdentifiers.contains(where: { ($0 as? NSManagedObject)?.objectID == objects[0].objectID }) else { return false }
			guard snapshotReference.itemIdentifiers.contains(where: { ($0 as? NSManagedObject)?.objectID == objects[1].objectID }) else { return false }
			return true
		})), count: .once)

		delegate.verify(.controller(.value(controllerTwo), didChangeContentWith: .matching({ snapshotReference in
			guard snapshotReference.sectionIdentifiers.count == 1 else { return false }
			guard snapshotReference.itemIdentifiers.count == 1 else { return false }
			guard snapshotReference.itemIdentifiers.contains(where: { ($0 as? NSManagedObject)?.objectID == otherObjects[0].objectID }) else { return false }
			return true
		})), count: .once)
	}

	func testUpdate() {
		let objects = createItems(count: 2)
		database.save()
		database.update(object: objects[0]) {
			let name = $0.value(forKey: "name") as! String
			$0.setValue("\(name)\(name)", forKey: "name")
		}
		database.save()

		delegate.verify(.controller(.value(controllerOne), didChangeContentWith: .matching({ snapshotReference in
			guard snapshotReference.sectionIdentifiers.count == 1 else { return false }
			guard snapshotReference.itemIdentifiers.count == 2 else { return false }
			guard snapshotReference.itemIdentifiers.contains(where: { ($0 as? NSManagedObject)?.objectID == objects[0].objectID }) else { return false }
			guard snapshotReference.itemIdentifiers.contains(where: { ($0 as? NSManagedObject)?.objectID == objects[1].objectID }) else { return false }
			return true
		})), count: .exactly(2)) // 1x for creation, 1x for update
	}

	func testDeletion() {
		let objects = createItems(count: 4)
		let otherObjects = createOtherItems(count: 2)
		database.save()
		database.delete(objects: [objects[0], objects[1], otherObjects[0]])
		database.save()

		delegate.verify(.controller(.value(controllerOne), didChangeContentWith: .matching({ snapshotReference in
			guard snapshotReference.sectionIdentifiers.count == 1 else { return false }
			guard snapshotReference.itemIdentifiers.count == 2 else { return false }
			guard snapshotReference.itemIdentifiers.contains(where: { ($0 as? NSManagedObject)?.objectID == objects[2].objectID }) else { return false }
			guard snapshotReference.itemIdentifiers.contains(where: { ($0 as? NSManagedObject)?.objectID == objects[3].objectID }) else { return false }
			return true
		})), count: .once)

		delegate.verify(.controller(.value(controllerTwo), didChangeContentWith: .matching({ snapshotReference in
			guard snapshotReference.sectionIdentifiers.count == 1 else { return false }
			guard snapshotReference.itemIdentifiers.count == 1 else { return false }
			guard snapshotReference.itemIdentifiers.contains(where: { ($0 as? NSManagedObject)?.objectID == otherObjects[1].objectID }) else { return false }
			return true
		})), count: .once)
	}
}

extension StaticFetchedCompositionalDataSourceTests {
	// MARK: - Helpers

	private var itemEntityName: String { "Item" }
	private var itemEntityDescription: NSEntityDescription {
		let entityDescription: NSEntityDescription = .init()
		entityDescription.name = itemEntityName
		return entityDescription
	}

	private var otherItemEntityName: String { "OtherItem" }
	private var otherItemEntityDescription: NSEntityDescription {
		let entityDescription: NSEntityDescription = .init()
		entityDescription.name = otherItemEntityName
		return entityDescription
	}

	private func createFetchedResultsController<T: NSFetchRequestResult>(entityName: String) -> NSFetchedResultsController<T> {
		let request: NSFetchRequest<T> = .init(entityName: entityName)
		request.sortDescriptors = [NSSortDescriptor(key: "section", ascending: true), NSSortDescriptor(key: "name", ascending: true)]
		return .init(fetchRequest: request, managedObjectContext: database.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
	}

	private func createItems(count: Int) -> [NSManagedObject] {
		database.create(entity: itemEntityDescription, count: count, section: nil)
	}

	private func createOtherItems(count: Int) -> [NSManagedObject] {
		database.create(entity: otherItemEntityDescription, count: count, section: nil)
	}
}
