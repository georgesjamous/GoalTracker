//
//  GoalProgress.swift
//  GoalTracker
//
//  Created by Georges on 3/5/21.
//

import Foundation
import Combine

fileprivate extension ProgressEvaluationResult {
    var goalProgressState: GoalProgressState {
        switch self {
        case .reached:
            return .reached
        case .notStarted:
            return .notStarted
        case .inProgress(percentage: let p):
            return .inProgress(percentage: p)
        }
    }
}

/// GoalProgressTracker is responsible to pull data from
/// for goals and health, then update then persist the goal progress.
class GoalProgressTracker {
    
    deinit {
        precondition(!isFetching, "Stop fetching first")
    }
    
    let goalFetching: GoalFetching
    let healthRecordFetching: HealthRecordFetching
    let progressPersisting: GoalProgressPersisting
    let queue = DispatchQueue(label: "com.domain.GoalProgressTracker", target: .tracker)
    
    private var cancellableSet = Set<AnyCancellable>()
    private(set) var isFetching = false
    
    init(
        goalFetching: GoalFetching,
        healthRecordFetching: HealthRecordFetching,
        progressPersisting: GoalProgressPersisting
    ) {
        self.goalFetching = goalFetching
        self.healthRecordFetching = healthRecordFetching
        self.progressPersisting = progressPersisting
        
        setupBinding()
    }
    
    private func setupBinding() {
        Publishers.CombineLatest(
            goalFetching.goalsPublisher,
            healthRecordFetching.goalsPublisher
        )
        .throttle(for: .milliseconds(500), scheduler: queue, latest: false)
        .sink { [weak self] (goals, healthRecord) in
            guard let self = self else { return }
            self.evaluateProgress(goals: goals, healthRecord: healthRecord)
            dispatchPrecondition(condition: .onQueue(self.queue))
        }.store(in: &cancellableSet)
    }
    
    public func startTracking() {
        guard !isFetching else { return }
        isFetching = true
        
        goalFetching.startFetching()
        healthRecordFetching.startFetching()
    }
    
    public func stopTracking() {
        guard isFetching else { return }
        isFetching = false
        
        goalFetching.stopFetching()
        healthRecordFetching.stopFetching()
    }
    
    func evaluateProgress(goals: [Goal], healthRecord: HealthRecord?) {
        guard let healthRecord = healthRecord else { return }
        let progress: [GoalProgress] = goals.map { (goal) in
            let progress = getProgress(goal: goal, health: healthRecord)
            let reward: GoalReward? = RewardGenerator().rewardForGoal(goal: goal, progress: progress)
            return GoalProgress(
                date: healthRecord.date,
                goalId: goal.id,
                progressState: progress.goalProgressState,
                reward: reward
            )
        }
        progressPersisting.saveGoalProgress(progress)
    }

    func getProgress(goal: Goal, health: HealthRecord) -> ProgressEvaluationResult {
        if let goal = goal as? StepCountGoal {
            return StepCountProgressEvaluator()
                .evaluateProgress(
                    goalCriteria: .init(stepCount: goal.stepCount),
                    progressCriteria: .init(stepCount: health.steps)
                )
        } else if let goal = goal as? WalkingDistanceGoal {
            return WalkedDistanceProgressEvaluator()
                .evaluateProgress(
                    goalCriteria: .init(distance: Int(goal.distanceInMeters)),
                    progressCriteria: .init(distance: health.distanceWalked)
                )
        } else if let goal = goal as? RunningDistanceGoal {
            return RanDistanceProgressEvaluator()
                .evaluateProgress(
                    goalCriteria: .init(distance: Int(goal.distanceInMeters)),
                    progressCriteria: .init(distance: health.distanceWalked)
                )
        }
        assertionFailure("Received an unkown type of goal")
        return .notStarted
    }
}
