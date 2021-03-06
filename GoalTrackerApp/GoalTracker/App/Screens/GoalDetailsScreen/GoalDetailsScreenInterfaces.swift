//
//  GoalDetailsScreenInterfaces.swift
//  GoalTracker
//
//  Created by Georges on 3/5/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit
import Combine

struct GoalDetailsScreenInput {
    let date: Date
    let goalFetching: GoalFetching
    let progressFetching: GoalProgressFetching
}

/// Wireframe
protocol GoalDetailsScreenWireframeInterface: WireframeInterface {
    init(input: GoalDetailsScreenInput)
}

/// Presenter -> View
protocol GoalDetailsScreenViewInterface: ViewInterface {
}

/// View -> Presenter
protocol GoalDetailsScreenPresenterInterface: PresenterInterface {
    func viewLoaded()
    func viewDidAppear()
    func viewWillDisappear()
    
    var titlePublisher: AnyPublisher<String, Never> { get }
    var detailsPublisher: AnyPublisher<String, Never> { get }
    var trophyPublisher: AnyPublisher<String, Never> { get }
    var progressPublisher: AnyPublisher<Double, Never> { get }
    var pointsPublisher: AnyPublisher<Int, Never> { get }
    var challengeNamePublisher: AnyPublisher<String, Never> { get }
    var challengeValuePublisher: AnyPublisher<Double, Never> { get }

}

/// Presenter -> Interactor
protocol GoalDetailsScreenInteractorInterface: InteractorInterface {
    var goalPublisher: AnyPublisher<Goal, Never> { get }
    var goalProgressPublisher: AnyPublisher<GoalProgress, Never> { get }
    
    func startFetchingUpdates()
    func stopFetchingUpdates()
}