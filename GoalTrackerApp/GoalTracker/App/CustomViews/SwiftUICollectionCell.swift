//
//  SwiftUITableCell.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import UIKit
import SwiftUI

/// SwiftUICollectionCell is a simple cell helper to embed swift ui views
///
/// Note:
/// this is the same as SwiftUITableCell, we could have merged both into
/// a single reusable component. for speed i coppied
class SwiftUICollectionCell: UICollectionViewCell {
    
    /// Required to attatch the SwiftUI View
    public weak var parentViewController: UIViewController?
    
    /// The current hosting view
    private var swiftUIhostingView: UIHostingController<AnyView>?
    
    public func setSwiftUIView(_ view: AnyView, padding: UIEdgeInsets = .zero) {
        guard let parentController = parentViewController else {
            assertionFailure("Attempted to insert a swift ui view without parent controller being registered")
            return
        }
        self.removeSwiftUIView()
        
        let hostingView = UIHostingController(rootView: view)
        hostingView.view.backgroundColor = .clear
        parentController.addChild(hostingView)
        contentView.embed(hostingView.view, insets: padding)
        hostingView.didMove(toParent: parentController)
        
        self.swiftUIhostingView = hostingView
        self.setNeedsLayout()
    }
    
    private func removeSwiftUIView() {
        guard let currentHosting = swiftUIhostingView else { return }
        currentHosting.willMove(toParent: nil)
        currentHosting.view.removeFromSuperview()
        currentHosting.removeFromParent()
        swiftUIhostingView = nil
        self.setNeedsLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        removeSwiftUIView()
    }
}
