//
//  FetchedChanges.swift
//  FetchedDataSource
//
//  Created by David Jennes on 27/12/16.
//  Copyright © 2016. All rights reserved.
//

import CoreData
import Foundation

struct FetchedChanges {
	var deletedObjects = Set<IndexPath>()
	var insertedObjects = Set<IndexPath>()
	var updatedObjects = Set<IndexPath>()
	var deletedSections = IndexSet()
	var insertedSections = IndexSet()
	var updatedSections = IndexSet()

	mutating func addObjectChange(type: NSFetchedResultsChangeType, path: IndexPath) {
		switch type {
		case .insert:
			if !insertedSections.contains(path.section) && !updatedSections.contains(path.section) {
				insertedObjects.insert(path)
			}
		case .delete:
			if !deletedSections.contains(path.section) && !updatedSections.contains(path.section) {
				deletedObjects.insert(path)
			}
		case .update:
			if !updatedSections.contains(path.section) {
				updatedObjects.insert(path)
			}
		case .move:
			break
		}
	}

	mutating func addSectionChange(type: NSFetchedResultsChangeType, index: Int) {
		switch type {
		case .insert:
			insertedSections.insert(index)
		case .delete:
			deletedSections.insert(index)
		case .update:
			updatedSections.insert(index)
		case .move:
			break
		}
	}
}
