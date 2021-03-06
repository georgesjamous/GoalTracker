//
//  StepGoal.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import Foundation

struct StepCountGoal: Goal {
    let id: String
    let title: String
    let description: String
    let stepCount: Int
    let trophy: RewardTrophy
    let points: Int
}
