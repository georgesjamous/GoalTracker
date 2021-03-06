//
//  MyGoalsScreenInterfaces.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit
import Combine

/// Wireframe
protocol MyGoalsScreenWireframeInterface: WireframeInterface {
    func routeToGoalDetails(date: Date, goalFetching: GoalFetching, progressFetching: GoalProgressFetching)
}

/// Presenter -> View
protocol MyGoalsScreenViewInterface: ViewInterface {
    func reloadView()
    func showLoader()
    func hideLoader()
    // todo: reload a specific index when a progess changes
    // instead of the whole view
    // func reloadIndex(index: Int)
}

/// View -> Presenter
protocol MyGoalsScreenPresenterInterface: PresenterInterface {
    
    // MARK: View Actions
    func viewLoaded()
    func viewDidAppear()
    func viewWillDisappear()
    func refresh()
    func goalSelected(index: Int)
    func nextDate()
    func previousDate()
    
    // MARK: View Data Srouce
    var viewTitle: String { get }
    var numberOfGoals: Int { get }
    func goalName(index: Int) -> String
    func goalProgress(index: Int) -> Double
    
}

/// Presenter -> Interactor
protocol MyGoalsScreenInteractorInterface: InteractorInterface {
    
    // MARK: Event Publishers
    var goalsPublisher: AnyPublisher<[Goal], Never> { get }
    var refreshStatePublisher: AnyPublisher<MyGoalsScreenModels.RefreshState, Never> { get }
    var goalProgressPublisher: AnyPublisher<[GoalProgress], Never> { get }
    
    // MARK: Actions
    func refreshGoals()
    func setDate(date: Date)

    
    var date: Date { get }
    func goalFetching(goalId: String) -> GoalFetching
    func goalProgressFetching(goalId: String) -> GoalProgressFetching
}
