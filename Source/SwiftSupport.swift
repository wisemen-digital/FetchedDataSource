//
//  SwiftSupport.swift
//  FetchedDataSource
//
//  Created by David Jennes on 06/03/2017.
//  Copyright © 2018 Appwise. All rights reserved.
//

import UIKit

#if !(swift(>=4.2))
public extension UITableView {
	typealias RowAnimation = UITableViewRowAnimation
}
public extension UITableViewCell {
	typealias EditingStyle = UITableViewCellEditingStyle
}
extension UIViewController {
    func addChild(_ vc: UIViewController) {
    	addChildViewController(vc)
    }

    func didMove(toParent vc: UIViewController) {
    	didMove(toParentViewController: vc)
    }

    var isMovingFromParent: Bool {
    	return isMovingFromParentViewController
    }
}
#endif
