//
//  RunningDistanceGoal.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import Foundation

struct RunningDistanceGoal: Goal {
    let id: String
    let title: String
    let description: String
    let distanceInMeters: Double
    let trophy: RewardTrophy
    let points: Int
}
