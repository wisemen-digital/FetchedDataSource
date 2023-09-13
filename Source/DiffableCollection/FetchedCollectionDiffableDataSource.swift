//
//  FetchedCollectionDataSource (Diffable).swift
//  AppwiseCore
//
//  Created by Jonathan Provo on 14/03/2022.
//

import CoreData
import UIKit

/**

 Once automated testing rock has advanced far enough, add tests.
 Edge cases:
 - displaying the same item in multiple sections simultaneously should be supported
 - displaying multiple sections using `sectionNameKeyPath` should use the correct order
 - displaying multiple sections using `DiffableCompoundFetchedResultsController` should use the correct order
 - removing the last item from a section should delete the entire section

 */

@available(iOS 13.0, *)
public typealias FetchedDiffableDataSource = UICollectionViewDiffableDataSource<FetchedDiffableSection, FetchedDiffableItem>

@available(iOS 13.0, *)
public final class FetchedCollectionDiffableDataSource: NSObject, NSFetchedResultsControllerDelegate {
	// MARK: - Properties
	/// A boolean indicating whether empty sections should be hidden or not. The default value is `true`.
	public var isHidingEmptySections: Bool
	/// A boolean indicating whether updated items should be reconfigured or reloaded. Setting this value to `true` will reconfigure items, setting this value to `false` will reload items. The default value is `true`.
	public var isReconfiguringItems: Bool = true
	/// A boolean indicating whether differences should be animated. The default value is `true`.
	public var isAnimatingDifferences: Bool = true
	/// A boolean indicating whether snapshot updates should be applied immediately. Changes occuring to the snapshot will remain pending until the next time this value is set to `true`. The default value is `true`.
	public var isUpdatingAutomatically: Bool {
		didSet {
			guard isUpdatingAutomatically else { return }
			applyPendingSnapshot()
		}
	}

	private let controller: NSFetchedResultsController<NSFetchRequestResult>
	private let dataSource: FetchedDiffableDataSource
	private lazy var internalSnapshot: NSDiffableDataSourceSnapshot<FetchedDiffableSection, FetchedDiffableItem> = .init() // non-modifiable snapshot to maintain data integrity, this snapshot stays in sync with the database
	private var pendingSnapshot: NSDiffableDataSourceSnapshot<FetchedDiffableSection, FetchedDiffableItem>? // store pending changes while `isUpdatingAutomatically` is set to `false`
	private weak var delegate: FetchedCollectionDiffableDataSourceDelegate?

	// MARK: - Lifecycle

	/// Creates a diffable data source based on a `NSFetchedResultsController` instance.
	public init(controller: NSFetchedResultsController<NSFetchRequestResult>, dataSource: FetchedDiffableDataSource, delegate: FetchedCollectionDiffableDataSourceDelegate? = nil, isHidingEmptySections: Bool = true, isUpdatingAutomatically: Bool = true) {
		self.controller = controller
		self.dataSource = dataSource
		self.delegate = delegate
		self.isHidingEmptySections = isHidingEmptySections
		self.isUpdatingAutomatically = isUpdatingAutomatically
		super.init()
		commonInit()
	}

	private func commonInit() {
		setDelegate()
		performFetch()
	}

	// MARK: - Controller management

	/// Sets the delegate of the NSFetchedResultsController instance.
	private func setDelegate() {
		controller.delegate = self
	}

	/// Executes the fetch request of the NSFetchedResultsController instance.
	private func performFetch() {
		do {
			try controller.performFetch()
		} catch let error {
			assertionFailure("Error performing controller fetch: \(error)")
		}
	}

	// MARK: - NSFetchedResultsControllerDelegate

	public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
		var itemsBeforeChange = internalSnapshot.itemIdentifiers
		let typedSnapshot = transform(snapshot: snapshot, context: controller.managedObjectContext)
		updateInternalSnapshot(withChangedContent: typedSnapshot, maintainSectionOrder: !(controller.sectionNameKeyPath?.isEmpty ?? true)) // maintain section order for FRC's with `sectionNameKeyPath` set
		var externalSnapshot = internalSnapshot // modifiable snapshot to be displayed
		delegate?.contentChangeWillBeApplied(snapshot: &externalSnapshot)

		var itemsAfterChange = externalSnapshot.itemIdentifiers
		var itemsToReconfigure = Array(Set(itemsBeforeChange).intersection(Set(itemsAfterChange)))
		if #available(iOS 15.0, *), isReconfiguringItems {
			externalSnapshot.reconfigureItems(itemsToReconfigure)
		} else {
			externalSnapshot.reloadItems(itemsToReconfigure)
		}

		if isUpdatingAutomatically {
			applySnapshot(snapshot: externalSnapshot)
		} else {
			pendingSnapshot = externalSnapshot
		}
	}

	// MARK: - Helpers

	/// Propagates changes from fetched results controllers into the internal snapshot.
	private func updateInternalSnapshot(withChangedContent snapshot: NSDiffableDataSourceSnapshot<String, FetchedDiffableItem>, maintainSectionOrder: Bool) {
		let indices: [String: Int]
		if maintainSectionOrder { // maintain section order according to `internalSnapshot`
			indices = snapshot.sectionIdentifiers.reduce(into: [:]) { result, sectionIdentifier in
				if let index = internalSnapshot.sectionIdentifiers.firstIndex(where: { $0.identifier == sectionIdentifier }) {
					result[sectionIdentifier] = index
				}
			}
		} else { // maintain section order according to `snapshot`
			indices = [:]
		}

		// delete all sections, as they will be inserted again anyway
		// this will prevent the issue where the last item from a section is not being removed properly
		internalSnapshot.deleteSections(internalSnapshot.sectionIdentifiers)

		// add all sections and items
		snapshot.sectionIdentifiers.forEach { sectionIdentifier in
			let section: FetchedDiffableSection = .init(identifier: sectionIdentifier)
			let items: [FetchedDiffableItem] = snapshot.itemIdentifiers(inSection: sectionIdentifier)
			if (isHidingEmptySections && !items.isEmpty) || !isHidingEmptySections {
				if let index = indices[sectionIdentifier], index < internalSnapshot.numberOfSections {
					let sectionAtIndex = internalSnapshot.sectionIdentifiers[index]
					internalSnapshot.insertSections([section], beforeSection: sectionAtIndex)
				} else {
					internalSnapshot.appendSections([section])
				}
				internalSnapshot.appendItems(items, toSection: section)
			}
		}
	}

	/// Transforms the `NSDiffableDataSourceSnapshotReference` into a `NSDiffableDataSourceSnapshot` object.
	private func transform(snapshot: NSDiffableDataSourceSnapshotReference, context: NSManagedObjectContext) -> NSDiffableDataSourceSnapshot<String, FetchedDiffableItem> {
		obtainPermanentIDs(for: snapshot.transform(), context: context)
	}

	/// The napshot returned by the `NSFetchedResultsController` instance contains temporary `NSManagedObjectID`s.
	/// Working with temporary identifiers can lead to issues since at some point in time they will no longer exist.
	private func obtainPermanentIDs(for snapshot: NSDiffableDataSourceSnapshot<String, FetchedDiffableItem>, context: NSManagedObjectContext) -> NSDiffableDataSourceSnapshot<String, FetchedDiffableItem> {
		guard snapshot.itemIdentifiers.contains(where: { $0.object is NSManagedObjectID }) else { return snapshot }
		var snapshotWithPermanentIDs: NSDiffableDataSourceSnapshot<String, FetchedDiffableItem> = .init()
		snapshot.sectionIdentifiers.forEach { sectionIdentifier in
			let itemsInSection = snapshot.itemIdentifiers(inSection: sectionIdentifier)
			if itemsInSection.allSatisfy({ $0.object is NSManagedObjectID }) {
				do {
					let objectIDs: [NSManagedObjectID] = itemsInSection.compactMap { $0.item() }
					let objects: [NSManagedObject] = objectIDs.map { context.object(with: $0) }
					try context.obtainPermanentIDs(for: objects)
					snapshotWithPermanentIDs.appendSections([sectionIdentifier])
					snapshotWithPermanentIDs.appendItems(objects.map { .init(item: $0, sectionIdentifier: sectionIdentifier) }, toSection: sectionIdentifier)
				} catch {
					snapshotWithPermanentIDs.appendSections([sectionIdentifier])
				}
			} else {
				snapshotWithPermanentIDs.appendSections([sectionIdentifier])
				snapshotWithPermanentIDs.appendItems(itemsInSection, toSection: sectionIdentifier)
			}
		}
		return snapshotWithPermanentIDs
	}

	private func applySnapshot(snapshot: NSDiffableDataSourceSnapshot<FetchedDiffableSection, FetchedDiffableItem>) {
		DispatchQueue.main.async {
			self.delegate?.willChangeContent()
			self.dataSource.apply(snapshot, animatingDifferences: self.isAnimatingDifferences) { [weak self] in
				self?.delegate?.didChangeContent()
			}
		}
	}

	private func applyPendingSnapshot() {
		guard let pendingSnapshot else { return }
		defer { self.pendingSnapshot = nil }
		applySnapshot(snapshot: pendingSnapshot)
	}
}

@available(iOS 13.0, *)
private extension NSDiffableDataSourceSnapshotReference {
	func transform() -> NSDiffableDataSourceSnapshot<String, FetchedDiffableItem> {
		if itemIdentifiers.allSatisfy({ $0 is FetchedDiffableItem }) {
			return self as NSDiffableDataSourceSnapshot<String, FetchedDiffableItem>
		} else {
			return doTransform()
		}
	}

	private func doTransform() -> NSDiffableDataSourceSnapshot<String, FetchedDiffableItem> {
		var typedSnapshot = self as NSDiffableDataSourceSnapshot<String, NSObject>
		var transformedSnapshot: NSDiffableDataSourceSnapshot<String, FetchedDiffableItem> = .init()
		typedSnapshot.sectionIdentifiers.forEach { sectionIdentifier in
			transformedSnapshot.appendSections([sectionIdentifier])
			transformedSnapshot.appendItems(typedSnapshot.itemIdentifiers(inSection: sectionIdentifier).map { .init(item: $0, sectionIdentifier: sectionIdentifier) }, toSection: sectionIdentifier)
		}
		return transformedSnapshot
	}
}
