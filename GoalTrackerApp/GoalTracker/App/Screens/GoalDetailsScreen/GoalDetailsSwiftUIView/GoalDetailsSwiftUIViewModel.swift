//
//  GoalDetailsSwiftUIViewModel.swift
//  GoalTracker
//
//  Created by Georges on 3/6/21.
//

import Foundation
import SwiftUI

// no need to abstract with protocol for now
class GoalDetailsSwiftUIViewModel: ObservableObject {
    
    @Published var goalName: String = ""
    @Published var date: Date = Date()
    @Published var goalDetails: String = ""
    @Published var rewardPoints: Int = 0
    @Published var rewardTrophy: String = ""
    @Published var criteriaName: String = ""
    @Published var criteriaValue: Double = 0
    var percentageComplete: Double = 0 {
        didSet {
            withAnimation {
                self.objectWillChange.send()
            }
        }
    }
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
    var goalDate: String {
        dateFormatter.string(from: date)
    }
    
}
