//
//  FetchedCompositionalDataSource.swift
//  FetchedDataSource
//
//  Created by Jonathan Provo on 08/02/2022.
//

import CoreData
import UIKit

/// This class is responsible for composing different data sources into a single one.
/// Internally there are, depending on the composition of the data source, 1 or more `NSFetchedResultsController` backing instances.
///
/// This class is designed to work with `UICollectionView` instances configured with a `UICollectionViewDiffableDataSource`.
/// Usage of this class makes it possible to combine different types of data models into a single `UICollectionView` instance.
///
/// Some considerations:
/// 1. Within a single section there is no support to combine types of data models, i.e. only 1, and exactly 1, type of data model can be used.
/// 2. Keep a strong reference to the instance of this class after creating it.
@available(iOS 14.0, *)
public final class FetchedCompositionalDataSource<SectionType: CompositionalSectionType, ItemType: CompositionalItemType>: NSObject, NSFetchedResultsControllerDelegate {
	// MARK: - Properties

	/// A boolean indicating whether differences should be animated. The default value is `true`.
	public var isAnimatingDifferences: Bool = true

	private let controllersBySection: [(section: SectionType, controller: CompositionalFetchedResultsController)]?
	private let controllers: [CompositionalFetchedResultsController]
	private let dataSource: UICollectionViewDiffableDataSource<SectionType, ItemType>
	private let delegate: FetchedCompositionalDataSourceDelegate

	private var sections: [SectionType]? {
		controllersBySection?.map(\.section)
	}

	// MARK: - Lifecycle

	/// Creates a compositional data source with static sections.
	/// The sections are provided through the `controllers` parameter, each section is backed by a controller.
	public static func `static`(controllers: [SectionType: CompositionalFetchedResultsController], dataSource: UICollectionViewDiffableDataSource<SectionType, ItemType>, delegate: FetchedCompositionalDataSourceDelegate) -> Self {
		Self.init(controllers: controllers, dataSource: dataSource, delegate: delegate)
	}

	/// Creates a compositional data source with dynamic sections.
	/// The sections are provided by the `controller`'s `sectionNameKeyPath` value.
	public static func dynamic(controller: CompositionalFetchedResultsController, dataSource: UICollectionViewDiffableDataSource<SectionType, ItemType>, delegate: FetchedCompositionalDataSourceDelegate) -> Self {
		Self.init(controller: controller, dataSource: dataSource, delegate: delegate)
	}

	private init(controllers: [SectionType: CompositionalFetchedResultsController], dataSource: UICollectionViewDiffableDataSource<SectionType, ItemType>, delegate: FetchedCompositionalDataSourceDelegate) {
		controllersBySection = controllers.sorted { $0.key.index < $1.key.index }.map { ($0, $1) }
		self.controllers = controllers.map(\.value)
		self.dataSource = dataSource
		self.delegate = delegate
		super.init()
		commonInit()
	}

	private init(controller: CompositionalFetchedResultsController, dataSource: UICollectionViewDiffableDataSource<SectionType, ItemType>, delegate: FetchedCompositionalDataSourceDelegate) {
		controllersBySection = nil
		controllers = [controller]
		self.dataSource = dataSource
		self.delegate = delegate
		super.init()
		commonInit()
	}

	private func commonInit() {
		applyEmptySections()
		setDelegates()
		performFetches()
	}

	// MARK: - Controller management

	/// Applies empty sections to secure the order of the sections.
	private func applyEmptySections() {
		guard let sections = sections else { return }
		guard dataSource.snapshot().numberOfSections == 0 else { return }
		var snapshot: NSDiffableDataSourceSnapshot<SectionType, ItemType> = .init()
		snapshot.appendSections(sections)
		dataSource.apply(snapshot, animatingDifferences: false, completion: nil)
	}

	/// Sets the delegates of all NSFetchedResultsControlle instances.
	private func setDelegates() {
		controllers.forEach { $0.set(delegate: self) }
	}

	/// Executes the fetch requests of all NSFetchedResultsController instances.
	public func performFetches() {
		do {
			try controllers.forEach { try $0.performFetch() }
		} catch let error {
			assertionFailure("Error performing controller fetch: \(error)")
		}
	}

	// MARK: - NSFetchedResultsControllerDelegate

	public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		delegate.willChangeContent()
	}

	public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
		let snapshotWithPermanentIDs = obtainPermanentIDs(for: snapshot, in: controller.managedObjectContext)
		delegate.controller(controller, didChangeContentWith: snapshotWithPermanentIDs)
		let typedSnapshot = snapshotWithPermanentIDs as NSDiffableDataSourceSnapshot<String, NSManagedObject>

		if let section = controllersBySection?.first(where: { $0.controller.isEqual(to: controller) })?.section {
			var sectionSnapshot: NSDiffableDataSourceSectionSnapshot<ItemType> = .init()
			let items: [ItemType] = typedSnapshot.itemIdentifiers.map { .init(managedObject: $0) }
			sectionSnapshot.append(items)
			dataSource.apply(sectionSnapshot, to: section, animatingDifferences: isAnimatingDifferences)
		} else {
			var snapshot: NSDiffableDataSourceSnapshot<SectionType, ItemType> = .init()
			typedSnapshot.sectionIdentifiers.forEach { sectionIdentifier in
				if let section: SectionType = .init(identifier: sectionIdentifier) {
					let items: [ItemType] = typedSnapshot.itemIdentifiers(inSection: sectionIdentifier).map { .init(managedObject: $0) }
					snapshot.appendSections([section])
					snapshot.appendItems(items, toSection: section)
				}
			}
			dataSource.apply(snapshot, animatingDifferences: isAnimatingDifferences, completion: nil)
		}
	}

	public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		delegate.didChangeContent()
	}

	// MARK: - Helpers

	/// The snapshot returned by the `NSFetchedResultsController` instance contains temporary `NSManagedObjectID`s.
	/// Working with temporary identifiers can lead to issues since at some point in time they will no longer exist.
	private func obtainPermanentIDs(for snapshot: NSDiffableDataSourceSnapshotReference, in context: NSManagedObjectContext) -> NSDiffableDataSourceSnapshotReference {
		let typedSnapshot = snapshot as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>
		let snapshotWithPermanentIDs: NSDiffableDataSourceSnapshotReference = .init()
		typedSnapshot.sectionIdentifiers.forEach { sectionIdentifier in
			do {
				let objects = typedSnapshot.itemIdentifiers(inSection: sectionIdentifier).map { context.object(with: $0) }
				try context.obtainPermanentIDs(for: objects)
				snapshotWithPermanentIDs.appendSections(withIdentifiers: [sectionIdentifier])
				snapshotWithPermanentIDs.appendItems(withIdentifiers: objects, intoSectionWithIdentifier: sectionIdentifier)
			} catch {
				snapshotWithPermanentIDs.appendSections(withIdentifiers: [sectionIdentifier])
			}
		}
		return snapshotWithPermanentIDs
	}
}
