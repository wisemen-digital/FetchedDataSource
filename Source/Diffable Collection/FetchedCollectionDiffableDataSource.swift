//
//  FetchedCollectionDataSource (Diffable).swift
//  AppwiseCore
//
//  Created by Jonathan Provo on 14/03/2022.
//

import CoreData
import UIKit

@available(iOS 13.0, *)
public typealias FetchedDiffableDataSource = UICollectionViewDiffableDataSource<FetchedDiffableSection, FetchedDiffableItem>

@available(iOS 13.0, *)
public final class FetchedCollectionDiffableDataSource: NSObject, NSFetchedResultsControllerDelegate {
	// MARK: - Properties
	/// A boolean indicating whether updated items should be reconfigured or reloaded. Setting this value to `true` will reconfigure items, setting this value to `false` will reload items. The default value is `true`.
	public var isReconfiguringItems: Bool = true
	/// A boolean indicating whether differences should be animated. The default value is `true`.
	public var isAnimatingDifferences: Bool = true
	/// A boolean indicating whether snapshot updates should be applied immediately. Changes occuring to the snapshot will remain pending until the next time this value is set to `true`. The default value is `true`.
	public var isUpdatingAutomatically: Bool = true {
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
	public init(controller: NSFetchedResultsController<NSFetchRequestResult>, dataSource: FetchedDiffableDataSource, delegate: FetchedCollectionDiffableDataSourceDelegate) {
		self.controller = controller
		self.dataSource = dataSource
		self.delegate = delegate
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

		let snapshotWithPermanentIDs = obtainPermanentIDs(for: snapshot, in: controller.managedObjectContext)
		let typedSnapshot = snapshotWithPermanentIDs as NSDiffableDataSourceSnapshot<String, NSManagedObject>
		typedSnapshot.sectionIdentifiers.forEach { sectionIdentifier in
			let section: FetchedDiffableSection = .init(identifier: sectionIdentifier)
			internalSnapshot.deleteSections([section])
			let items: [FetchedDiffableItem] = typedSnapshot.itemIdentifiers(inSection: sectionIdentifier).map { .init(item: $0) }
			internalSnapshot.appendSections([section])
			internalSnapshot.appendItems(items, toSection: section)
		}

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

	private func applySnapshot(snapshot: NSDiffableDataSourceSnapshot<FetchedDiffableSection, FetchedDiffableItem>) {
		delegate?.willChangeContent()
		dataSource.apply(snapshot, animatingDifferences: isAnimatingDifferences) { [weak self] in
			self?.delegate?.didChangeContent()
		}
	}

	private func applyPendingSnapshot() {
		guard let pendingSnapshot else { return }
		defer { self.pendingSnapshot = nil }
		applySnapshot(snapshot: pendingSnapshot)
	}
}
