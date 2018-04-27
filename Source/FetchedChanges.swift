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
	var viewSectionsCache = [Int]()
	var deletedObjects = Set<IndexPath>()
	var insertedObjects = Set<IndexPath>()
	var updatedObjects = Set<IndexPath>()
	var movedObjects = [(from: IndexPath, to: IndexPath)]()
	var deletedSections = IndexSet()
	var insertedSections = IndexSet()
	var updatedSections = IndexSet()

	mutating func addObjectChange(type: NSFetchedResultsChangeType, path: IndexPath) {
		let section = path.section

		switch type {
		case .insert:
			if !insertedSections.contains(section) && !updatedSections.contains(section) {
				insertedObjects.insert(path)
			}
		case .delete:
			if !deletedSections.contains(section) && !updatedSections.contains(section) {
				deletedObjects.insert(path)
			}
		case .update:
			if !insertedSections.contains(section) && !deletedSections.contains(section) && !updatedSections.contains(section) {
				updatedObjects.insert(path)
			}
		case .move:
			break
		}
	}

	mutating func addObjectMove(from: IndexPath, to: IndexPath) {
		// only move when both sections still exist, haven't been udpated, and we're actually moving to a different path
		if from == to {
			addObjectChange(type: .update, path: to)
		} else if deletedSections.contains(from.section) || updatedSections.contains(from.section) {
			addObjectChange(type: .insert, path: to)
		} else if insertedSections.contains(to.section) || updatedSections.contains(to.section) {
			addObjectChange(type: .delete, path: from)
		} else {
			movedObjects += [(from: from, to: to)]
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
