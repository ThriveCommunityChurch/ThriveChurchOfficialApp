//
//  UITableViewExtension.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 1/6/19.
//  Copyright © 2019 Thrive Community Church. All rights reserved.
//

import UIKit

extension UITableView {
	
	public func deselectRow(indexPath: IndexPath) {
		// Change the selected background view of the cell back to unselected
		self.deselectRow(at: indexPath, animated: true)
	}
	
}
