//
//  UITableViewCell+Identity.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import UIKit

protocol IdentifiableTableViewCell: UITableViewCell {
    static var identity: String { get }
    static var xib: UINib { get }
}

extension UITableViewCell: IdentifiableTableViewCell {
    static var identity: String { String(describing: self) }
    static var xib: UINib { UINib(nibName: identity, bundle: .main) }
}
