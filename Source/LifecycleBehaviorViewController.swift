//
//  LifecycleBehaviorViewController.swift
//  FetchedDataSource
//
//  Created by David Jennes on 08/11/17.
//  Copyright © 2017. All rights reserved.
//

import CoreData
import UIKit

final class LifecycleBehaviorViewController<ResultType: NSFetchRequestResult, DelegateType: FetchedDataSourceDelegate>: UIViewController {
	weak var source: FetchedDataSource<ResultType, DelegateType>?

	required init(source: FetchedDataSource<ResultType, DelegateType>) {
		self.source = source
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("Unsupported init with coder")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.isHidden = true
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		source?.isVisible = true
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		source?.isVisible = false
	}
}
