//
//  MyGoalsScreenInteractorUsecase.swift
//  GoalTracker
//
//  Created by Georges on 3/6/21.
//

import Foundation
import Combine

//
//protocol MyGoalsScreenInteractorUsecase {
//    var goalsPublisher: AnyPublisher<[Goal], Never> { get }
//    var pogressPublisher: AnyPublisher<[GoalProgress], Never> { get }
//    func startFetching()
//    func stopFetching()
//}

class MyGoalsScreenInteractorUsecase {
    
    deinit {
        // Note:
        // this prevents the issue where if we expected the class to deallocates and it didnt
        // we would have two problems. Memory leak and continuous fetching.
        // By explicitly stoping fetch when we want, even fi the view does not deallocates we will
        precondition(!isFetching, "You have to call stopFetching: before deallocating")
    }
    
    // todo: we might need to lock this later
    private(set) var isFetching: Bool = false
    
    let goalFetching: GoalFetching
    let progressFetching: GoalProgressFetching
    let progressTracker: GoalProgressTracker
    let healtServcieTracker: HealthServiceTracker
    
    init(
        date: Date,
        goalDataProvider: UserGoalsServiceDataProviding,
        goalProgressProvider: GoalProgressServiceDataProviding,
        healthDataProvider: HealthDataServiceDataProviding
    ) {
        goalFetching = goalDataProvider.fetchController(goalId: nil)
        progressFetching = goalProgressProvider.fetchController(date: date, goalId: nil)
        progressTracker = goalProgressProvider.progressTracker(date: date, goalId: nil)
        healtServcieTracker = healthDataProvider.healthRecordsTracker(date: date)
    }
    
    var goalsPublisher: AnyPublisher<[Goal], Never> {
        goalFetching.goalsPublisher
    }
    
    var pogressPublisher: AnyPublisher<[GoalProgress], Never> {
        progressFetching.progressPublisher
    }
    
    func startFetching() {
        guard !isFetching else { return }
        isFetching = true
        
        goalFetching.startFetching()
        progressFetching.startFetching()
        progressTracker.startTracking()
        healtServcieTracker.startFetching()
    }
    
    func stopFetching() {
        guard isFetching else { return }
        isFetching = false
        
        goalFetching.stopFetching()
        progressFetching.stopFetching()
        progressTracker.stopTracking()
        healtServcieTracker.stopFetching()
    }
    
}
