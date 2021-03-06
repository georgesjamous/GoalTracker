//
//  UIView+Embedding.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import UIKit

extension UIView {
    /// Embed a view within a parent using constraints
    /// - Parameters:
    ///   - childView: the child view to embed
    ///   - spacing: edge spacing
    func embed(_ childView: UIView, insets: UIEdgeInsets = UIEdgeInsets.zero) {
        addSubview(childView)
        childView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            childView.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            childView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
            childView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right),
            childView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom)
        ])
    }
}
