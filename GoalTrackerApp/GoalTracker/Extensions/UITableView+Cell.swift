//
//  UITableView+CellRegistration.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import UIKit

extension UITableView {
    
    /// Returns a dequeued cell at index
    func dequeueCell<T: UITableViewCell>(indexPath: IndexPath) -> T {
        if let cell = dequeueReusableCell(withIdentifier: T.identity, for: indexPath) as? T {
            return cell
        }
        assertionFailure(
            "Could not dequeue cell for type \(T.self) at index \(indexPath). Have you registered the correct identifier?"
        )
        // Try to gracefully proceed in Production
        return T(style: .default, reuseIdentifier: T.identity)
    }
    
    /// register a cell class
    func registerCell(_ cell: IdentifiableTableViewCell.Type) {
        self.register(
            cell.self,
            forCellReuseIdentifier: cell.identity
        )
    }
    
    /// register a cell nib
    func registerCellNib(_ cell: IdentifiableTableViewCell.Type) {
        self.register(
            .init(nibName: cell.identity, bundle: .main),
            forCellReuseIdentifier: cell.identity
        )
    }
}
