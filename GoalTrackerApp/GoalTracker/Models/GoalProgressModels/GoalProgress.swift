//
//  GoalProgress.swift
//  GoalTracker
//
//  Created by Georges on 3/5/21.
//

import Foundation

enum GoalProgressState {
    case reached
    case notStarted
    /// percentage is from 0 to 1
    case inProgress(percentage: Double)
    
    init(_ percentage: Double) {
        switch percentage {
        case 0:
            self = .notStarted
        case 1:
            self = .reached
        default:
            self = .inProgress(percentage: percentage)
        }
    }
}

struct GoalProgress {
    let date: Date
    let goalId: String
    let progressState: GoalProgressState
    let reward: GoalReward?
    
    var percentageProgress: Double {
        switch progressState {
        case .notStarted:
            return 0
        case .inProgress(percentage: let p):
            return p
        case .reached:
            return 1
        }
    }
}

extension GoalProgress: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(goalId)
    }
    static func == (lhs: GoalProgress, rhs: GoalProgress) -> Bool {
        lhs.goalId == rhs.goalId
    }
}

//
//struct StepGoalProgress: GoalProgressInterface {
//    let goalId: String
//    let progress: GoalProgress
//    let stepCount: Int
//    let stepGoal: Int
//}
//
//struct DistanceWalkedGoalProgress: GoalProgressInterface {
//    let goalId: String
//    let progress: GoalProgress
//    let meterDistance: Int
//    let meterDistanceGoal: Int
//}
//
//struct DistanceRanGoalProgress: GoalProgressInterface {
//    let goalId: String
//    let progress: GoalProgress
//    let meterDistance: Int
//    let meterDistanceGoal: Int
//}
