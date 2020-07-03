# Migration Guide

## 5.0.0

### Obsolete delegate

The custom data source protocol has been obsoleted in favour of the UIKit ones. Xcode **will** generate errors for all of these, and even provide fix-its. Unfortunately, the fix-its don't work very well, so you're better of finding & replacing instances in your whole project:

For table views, find:

```swift
func cell(for indexPath: IndexPath, view: UITableView) -> UITableViewCell {
```

And replace it with:

```swift
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
```

For collection views, find:

```swift
func cell(for indexPath: IndexPath, view: UICollectionView) -> UICollectionViewCell {
```

And replace it with:

```swift
override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
```

### Deprecated factory methods

The factory methods `FetchedDataSource.for(...)` have been deprecated in favour of directly invoking the constructors. Xcode will generate warnigns and provide fix-its, but because the parameter order doesn't match, they don't work very well.

After applying the fix-it, you'll need to change the order of the values. For table views, this:

```swift
source = FetchedDataSource.for(tableView: tableView, controller: repository.frc, delegate: self)
```

Becomes this (note the switched controller & view arguments):

```swift
source = FetchedTableDataSource(controller: repository.frc, view: tableView, delegate: self)
```

Same thing for collection views:

```swift
source = FetchedDataSource.for(collectionView: collectionView, controller: repository.frc, delegate: self)
```

Becomes:

```swift
source = FetchedCollectionDataSource(controller: repository.frc, view: collectionView, delegate: self)
```

## 4.0.0

### Obsolete object(at:)

For safety reasons, the `object(at:)` method has been obsoleted for one that returns an optional result. Xcode will generate errors for this.

To fix them, change code like:

```swift
let item = source.object(at: indexPath)
```

To something like this:

```swift
if let item = source.object(at: indexPath) {
	...
}
```
