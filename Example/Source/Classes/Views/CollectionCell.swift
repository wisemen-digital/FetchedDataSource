//
//  CollectionCell.swift
//  Example
//
//  Created by Jonathan Provo on 17/02/2022.
//  Copyright © 2022 Appwise. All rights reserved.
//

import Reusable
import UIKit

class CollectionCell: UICollectionViewCell, Reusable {
	@IBOutlet var textLabel: UILabel!
	@IBOutlet var detailTextLabel: UILabel!

	private lazy var _stackView: UIStackView = {
		let stackView = UIStackView(frame: .zero)
		stackView.axis = .vertical
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()
	private lazy var _titleLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.adjustsFontSizeToFitWidth = true
		label.minimumScaleFactor = 0.5
		label.font = UIFont.systemFont(ofSize: 17)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	private lazy var _subtitleLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.font = UIFont.systemFont(ofSize: 12)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		configureSubviews()
	}

	func configure(item: Item) {
		textLabel.text = item.name
		detailTextLabel.text = "Fetched Value"
	}

	func configure(name: String?) {
		textLabel.text = name
		detailTextLabel.text = "Fetched Value"
	}

	private func configureSubviews() {
		textLabel = _titleLabel
		detailTextLabel = _subtitleLabel
		_stackView.addArrangedSubview(textLabel)
		_stackView.addArrangedSubview(detailTextLabel)
		contentView.addSubview(_stackView)
		contentView.backgroundColor = .systemGray.withAlphaComponent(0.25)
		NSLayoutConstraint.activate([
			_stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			_stackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
			_stackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
		])
	}
}
