//
//  TitleHeader.swift
//  Example
//
//  Created by Jonathan Provo on 17/02/2022.
//  Copyright © 2022 Appwise. All rights reserved.
//

import Reusable
import UIKit

public final class TitleHeader: UICollectionReusableView, Reusable {
	@IBOutlet public var titleLabel: UILabel!

	private lazy var _titleLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
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

	private func configureSubviews() {
		titleLabel = _titleLabel
		addSubview(titleLabel)
		NSLayoutConstraint.activate([
			titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
			titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
			titleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
		])
	}
}
