//
//  OtherItem.swift
//  Example
//
//  Created by Jonathan Provo on 17/02/2022.
//  Copyright © 2022 Appwise. All rights reserved.
//

import MagicalRecord

extension OtherItem {
	static var allfrc: NSFetchedResultsController<OtherItem> {
		return OtherItem.mr_fetchAllGrouped(by: nil,
									   with: nil,
									   sortedBy: "\(#keyPath(OtherItem.section)),\(#keyPath(OtherItem.name))",
									   ascending: true,
									   in: .mr_default()) as! NSFetchedResultsController<OtherItem>
	}
}
