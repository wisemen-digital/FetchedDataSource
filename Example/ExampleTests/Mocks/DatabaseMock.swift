//
//  DatabaseMock.swift
//  ExampleTests
//
//  Created by Jonathan Provo on 22/02/2022.
//  Copyright © 2022 Appwise. All rights reserved.
//

import CoreData

class DatabaseMock {
	// MARK: - Properties

	private var persistentContainer: NSPersistentContainer!
	var managedObjectContext: NSManagedObjectContext {
		persistentContainer.viewContext
	}

	// MARK: - Lifecycle

	init() {
		setUpCoreDataStack()
	}

	// MARK: - Core Data

	private func setUpCoreDataStack() {
		persistentContainer = .init(name: "Example")
		persistentContainer.persistentStoreDescriptions = [NSPersistentStoreDescription(url: .init(fileURLWithPath: "/dev/null"))]
		persistentContainer.loadPersistentStores { _, _ in
		}
	}

	// MARK: - CRUD

	func create(entity: NSEntityDescription, count: Int, section: String?) -> [NSManagedObject] {
		let objects = (0..<count).map { _ in
			create(entity: entity, section: section)
		}
		return objects
	}

	private func create(entity: NSEntityDescription, section: String?) -> NSManagedObject {
		let object = NSEntityDescription.insertNewObject(forEntityName: entity.name!, into: managedObjectContext)
		object.setValue(section, forKey: "section")
		object.setValue(UUID().uuidString, forKey: "name")
		return object
	}

	func update<T: NSManagedObject>(object: T, configure: (T) -> Void) {
		configure(object)
	}

	func delete<T: NSManagedObject>(objects: [T]) {
		objects.forEach { managedObjectContext.delete($0) }
	}

	func save() {
		try! managedObjectContext.save()
	}
}
