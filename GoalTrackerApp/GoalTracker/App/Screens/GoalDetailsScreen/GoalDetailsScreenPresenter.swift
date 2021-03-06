//
//  GoalDetailsScreenPresenter.swift
//  GoalTracker
//
//  Created by Georges on 3/5/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit
import Combine

fileprivate extension Goal {
    var challengeCriteria: String {
        switch self {
        case _ as StepCountGoal:
            return "Step Count"
        case _ as WalkingDistanceGoal:
            return "Walking Distance"
        case _ as RunningDistanceGoal:
            return "Running Distance"
        default:
            return "-"
        }
    }
    // since they are all the same for now
    var challengeCriteriaAmount: Int {
        switch self {
        case let g as StepCountGoal:
            return g.stepCount
        case let g as WalkingDistanceGoal:
            return Int(g.distanceInMeters)
        case let g as RunningDistanceGoal:
            return Int(g.distanceInMeters)
        default:
            return 0
        }
    }
}

final class GoalDetailsScreenPresenter {

    // MARK: - Private properties -

    private unowned let view: GoalDetailsScreenViewInterface
    private let interactor: GoalDetailsScreenInteractorInterface
    private let wireframe: GoalDetailsScreenWireframeInterface
    var cancellableSet = Set<AnyCancellable>()

    var goal: Goal? {
        didSet {
            guard let goal = goal else { return }
            titleSubject.send(goal.description)
            detailsSubject.send(goal.title)
            pointsSubject.send(goal.points)
            trophySubject.send("\(goal.trophy)")
            pointsSubject.send(goal.points)
            challengeNameSubject.send(goal.challengeCriteria)
        }
    }
    
    var goalProgress: GoalProgress? {
        didSet {
            guard let goalProgress = goalProgress else { return }
            progressSubject.send(goalProgress.percentageProgress)
            
            // note: edgecase here!
            if let goal = goal {
                challengeValueSubject.send(Double(goal.challengeCriteriaAmount) * goalProgress.percentageProgress)
            }
        }
    }
    
    let titleSubject = PassthroughSubject<String, Never>()
    let detailsSubject = PassthroughSubject<String, Never>()
    let trophySubject = PassthroughSubject<String, Never>()
    let progressSubject = PassthroughSubject<Double, Never>()
    let pointsSubject = PassthroughSubject<Int, Never>()
    let challengeNameSubject = PassthroughSubject<String, Never>()
    let challengeValueSubject = PassthroughSubject<Double, Never>()
    
    // MARK: - Lifecycle -

    init(view: GoalDetailsScreenViewInterface, interactor: GoalDetailsScreenInteractorInterface, wireframe: GoalDetailsScreenWireframeInterface) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
    
    func bindToInteractor() {
        interactor
            .goalPublisher
            .compactMap({ $0 })
            .receive(on: DispatchQueue.main)
            .assignNoRetain(to: \.goal, on: self)
            .store(in: &cancellableSet)
        interactor
            .goalProgressPublisher
            .compactMap({ $0 })
            .receive(on: DispatchQueue.main)
            .assignNoRetain(to: \.goalProgress, on: self)
            .store(in: &cancellableSet)
    }
}

// MARK: - Extensions -

extension GoalDetailsScreenPresenter: GoalDetailsScreenPresenterInterface {
    
    func viewLoaded() {
        bindToInteractor()
        interactor.startFetchingUpdates()
    }
    
    func viewDidAppear() {
        interactor.startFetchingUpdates()
    }
    
    func viewWillDisappear() {
        interactor.stopFetchingUpdates()
    }
    
    var titlePublisher: AnyPublisher<String, Never> { titleSubject.eraseToAnyPublisher() }
    var detailsPublisher: AnyPublisher<String, Never> { detailsSubject.eraseToAnyPublisher() }
    var trophyPublisher: AnyPublisher<String, Never> { trophySubject.eraseToAnyPublisher() }
    var progressPublisher: AnyPublisher<Double, Never> { progressSubject.eraseToAnyPublisher() }
    var pointsPublisher: AnyPublisher<Int, Never> { pointsSubject.eraseToAnyPublisher() }
    var challengeNamePublisher: AnyPublisher<String, Never> { challengeNameSubject.eraseToAnyPublisher() }
    var challengeValuePublisher: AnyPublisher<Double, Never> { challengeValueSubject.eraseToAnyPublisher() }
}
