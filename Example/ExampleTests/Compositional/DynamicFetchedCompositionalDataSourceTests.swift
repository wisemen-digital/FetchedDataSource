//
//  DynamicFetchedCompositionalDataSourceTests.swift
//  ExampleTests
//
//  Created by Jonathan Provo on 23/02/2022.
//  Copyright © 2022 Appwise. All rights reserved.
//

import SwiftyMocky
import XCTest

@testable import FetchedDataSource

class DynamicFetchedCompositionalDataSourceTests: XCTestCase {
	// MARK: - Properties

	private var database: DatabaseMock!
	private var collectionView: UICollectionView!
	private var controller: NSFetchedResultsController<NSFetchRequestResult>!
	private var dataSource: CompositionalDynamicDataSource!
	private var delegate: FetchedCompositionalDataSourceDelegateMock!
	private var sut: FetchedCompositionalDataSource<CompositionalDynamicSection, CompositionalItem>!

	// MARK: - Set up & tear down

	override func setUp() {
		super.setUp()
		database = .init()
		collectionView = .init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
		controller = createFetchedResultsController(entityName: itemEntityName)
		dataSource = CompositionalDynamicDataSource.createDataSource(collectionView: collectionView)
		delegate = .init()
		sut = .dynamic(controller: .init(controller: controller), dataSource: dataSource, delegate: delegate)
	}

	override func tearDown() {
		super.tearDown()
	}

	// MARK: - Tests

	func testSections() {
		let snapshot = dataSource.snapshot()
		XCTAssertEqual(snapshot.sectionIdentifiers.count, 0)
	}

	func testShouldCallWillChange() {
		sut.controllerWillChangeContent(controller)

		delegate.verify(.willChangeContent(), count: .once)
	}

	func testShouldCallDidChange() {
		sut.controllerDidChangeContent(controller)

		delegate.verify(.didChangeContent(), count: .once)
	}

	func testCreation() {
		let objects1 = createItems(count: 1, section: "0")
		let objects2 = createItems(count: 2, section: "1")
		let objects3 = createItems(count: 3, section: "2")
		database.save()

		delegate.verify(.controller(.value(controller), didChangeContentWith: .matching({ snapshotReference in
			guard snapshotReference.sectionIdentifiers.count == 3 else { return false }
			guard snapshotReference.sectionIdentifiers.contains(where: { sectionIdentifier in
				let itemIdentifiers = snapshotReference.itemIdentifiersInSection(withIdentifier: sectionIdentifier)
				if sectionIdentifier as! String == "0" {
					guard itemIdentifiers.count == 1 else { return false }
					guard itemIdentifiers.contains(where: { ($0 as? NSManagedObject)?.objectID == objects1[0].objectID }) else { return false }
					return true
				} else if sectionIdentifier as! String == "1" {
					guard itemIdentifiers.count == 2 else { return false }
					guard itemIdentifiers.contains(where: { ($0 as? NSManagedObject)?.objectID == objects2[0].objectID }) else { return false }
					guard itemIdentifiers.contains(where: { ($0 as? NSManagedObject)?.objectID == objects2[1].objectID }) else { return false }
					return true
				} else if sectionIdentifier as! String == "2" {
					guard itemIdentifiers.count == 3 else { return false }
					guard itemIdentifiers.contains(where: { ($0 as? NSManagedObject)?.objectID == objects3[0].objectID }) else { return false }
					guard itemIdentifiers.contains(where: { ($0 as? NSManagedObject)?.objectID == objects3[1].objectID }) else { return false }
					guard itemIdentifiers.contains(where: { ($0 as? NSManagedObject)?.objectID == objects3[2].objectID }) else { return false }
					return true
				} else {
					return false
				}
			}) else { return false }
			return true
		})), count: .once)
	}

	func testUpdate() {
		let objects1 = createItems(count: 1, section: "0")
		let objects2 = createItems(count: 2, section: "1")
		database.save()
		database.update(object: objects1[0]) {
			let name = $0.value(forKey: "name") as! String
			$0.setValue("\(name)\(name)", forKey: "name")
		}
		database.save()

		delegate.verify(.controller(.value(controller), didChangeContentWith: .matching({ snapshotReference in
			guard snapshotReference.sectionIdentifiers.count == 2 else { return false }
			guard snapshotReference.sectionIdentifiers.contains(where: { sectionIdentifier in
				let itemIdentifiers = snapshotReference.itemIdentifiersInSection(withIdentifier: sectionIdentifier)
				if sectionIdentifier as! String == "0" {
					guard itemIdentifiers.count == 1 else { return false }
					guard itemIdentifiers.contains(where: { ($0 as? NSManagedObject)?.objectID == objects1[0].objectID }) else { return false }
					return true
				} else if sectionIdentifier as! String == "1" {
					guard itemIdentifiers.count == 2 else { return false }
					guard itemIdentifiers.contains(where: { ($0 as? NSManagedObject)?.objectID == objects2[0].objectID }) else { return false }
					guard itemIdentifiers.contains(where: { ($0 as? NSManagedObject)?.objectID == objects2[1].objectID }) else { return false }
					return true
				} else {
					return false
				}
			}) else { return false }
			return true
		})), count: .exactly(2)) // 1x for creation, 1x for update
	}

	func testDeletion() {
		let objects1 = createItems(count: 2, section: "0")
		let objects2 = createItems(count: 3, section: "1")
		let objects3 = createItems(count: 4, section: "2")
		database.save()
		database.delete(objects: [objects1[0], objects1[1], objects2[1], objects3[0], objects3[1]])
		database.save()

		delegate.verify(.controller(.value(controller), didChangeContentWith: .matching({ snapshotReference in
			guard snapshotReference.sectionIdentifiers.count == 2 else { return false }
			guard snapshotReference.sectionIdentifiers.contains(where: { sectionIdentifier in
				let itemIdentifiers = snapshotReference.itemIdentifiersInSection(withIdentifier: sectionIdentifier)
				if sectionIdentifier as! String == "1" {
					guard itemIdentifiers.count == 2 else { return false }
					guard itemIdentifiers.contains(where: { ($0 as? NSManagedObject)?.objectID == objects2[0].objectID }) else { return false }
					guard itemIdentifiers.contains(where: { ($0 as? NSManagedObject)?.objectID == objects2[2].objectID }) else { return false }
					return true
				} else if sectionIdentifier as! String == "2" {
					guard itemIdentifiers.count == 2 else { return false }
					guard itemIdentifiers.contains(where: { ($0 as? NSManagedObject)?.objectID == objects3[2].objectID }) else { return false }
					guard itemIdentifiers.contains(where: { ($0 as? NSManagedObject)?.objectID == objects3[3].objectID }) else { return false }
					return true
				} else {
					return false
				}
			}) else { return false }
			return true
		})), count: .once)
	}
}

extension DynamicFetchedCompositionalDataSourceTests {
	// MARK: - Helpers

	private var itemEntityName: String { "Item" }
	private var itemEntityDescription: NSEntityDescription {
		let entityDescription: NSEntityDescription = .init()
		entityDescription.name = itemEntityName
		return entityDescription
	}

	private func createFetchedResultsController<T: NSFetchRequestResult>(entityName: String) -> NSFetchedResultsController<T> {
		let request: NSFetchRequest<T> = .init(entityName: entityName)
		request.sortDescriptors = [NSSortDescriptor(key: "section", ascending: true), NSSortDescriptor(key: "name", ascending: true)]
		return .init(fetchRequest: request, managedObjectContext: database.managedObjectContext, sectionNameKeyPath: "section", cacheName: nil)
	}

	private func createItems(count: Int, section: String) -> [NSManagedObject] {
		database.create(entity: itemEntityDescription, count: count, section: section)
	}
}
