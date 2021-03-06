//
//  View+Hosting.swift
//  GoalTracker
//
//  Created by Georges on 3/6/21.
//

import SwiftUI

extension View {
    func hosted() -> UIHostingController<Self> {
        let hostingView = UIHostingController(rootView: self)
        hostingView.view.backgroundColor = .clear
        return hostingView
    }
}
