//
//  MyGoalsScreenGoalCell.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import UIKit
import SwiftUI

class MyGoalsScreenGoalCell: SwiftUITableCell {
    
    struct Model {
        let goalName: String
        let goalDescription: String
        let goalProgress: Double
    }
    
    var model: Model? = nil {
        didSet {
            if let model = model {
                modelChanged(model: model)
            }
        }
    }
    
    var view: MyGoalsScreenGoalCellSwiftUI?
    
    // MARK: Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func modelChanged(model: Model) {
        /// todo: add ability to update view with animation
        /// by gathering
        view = MyGoalsScreenGoalCellSwiftUI(
            title: model.goalName,
            subtitle: model.goalDescription,
            progress: model.goalProgress
        )
        setSwiftUIView(AnyView(view), padding: .init(top: 13, left: 15, bottom: 13, right: 15))
    }
}

