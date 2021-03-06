//
//  DistanceGoal.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import Foundation

struct WalkingDistanceGoal: Goal {
    let id: String
    let title: String
    let description: String
    let distanceInMeters: Double
    let trophy: RewardTrophy
    let points: Int
}
