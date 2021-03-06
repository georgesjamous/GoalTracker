//
//  MyGoalsScreenInteractor.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import Foundation
import Combine

final class MyGoalsScreenInteractor {
    
    private var cancellableSet: Set<AnyCancellable> = Set()

    lazy var goalServiceReader = Application.container.resolve(UserGoalsService.self)!
    lazy var progressServiceReader = Application.container.resolve(GoalProgressServiceDataProviding.self)!
    lazy var goalServiceWriter = Application.container.resolve(UserGoalsServiceDataControlling.self)!
    var usecase: MyGoalsScreenInteractorUsecase?
    var currentDate: Date = World.date
    
    let goalsSubject = PassthroughSubject<[Goal], Never>()
    let refreshStateSubject = PassthroughSubject<MyGoalsScreenModels.RefreshState, Never>()
    let goalProgressSubject = PassthroughSubject<[GoalProgress], Never>()
    let setDateBuffer = PassthroughSubject<Date, Never>()
    
    init() {
        setDateBuffer
            .throttle(for: .milliseconds(500), scheduler: RunLoop.current, latest: true)
            .sink { [weak self] (newDate) in
                guard let self = self else { return }
                self.changeDate(fromDate: self.currentDate, newDate: newDate)
            }.store(in: &cancellableSet)
    }
    
    // MARK: Date Switching
    
    func changeDate(fromDate: Date?, newDate: Date) {
        willChangeFromDate(date: fromDate)
        currentDate = newDate
        didChangeToDate(date: newDate)
    }
    
    func willChangeFromDate(date: Date?) {
        stopLiveUpdates()
        usecase = nil
    }
    
    func didChangeToDate(date: Date) {
        usecase = MyGoalsScreenInteractorUsecase(
            date: date,
            goalDataProvider: goalServiceReader,
            goalProgressProvider: progressServiceReader,
            healthDataProvider: Application.container.resolve(HealthDataServiceDataProviding.self)!
        )
        bindToNewUseCase(usecase!)
        startLiveUpdates()
    }
    
    // MARK: Live Update
    
    func stopLiveUpdates() {
        usecase?.stopFetching()
    }
    
    func startLiveUpdates() {
        usecase?.startFetching()
    }
    
    // MARK: Use Case Bidning
    
    func bindToNewUseCase(_ usecase: MyGoalsScreenInteractorUsecase) {
        usecase.goalsPublisher
            .sink { [weak self] (goals) in
                self?.goalsSubject.send(goals)
            }
            .store(in: &cancellableSet)
        usecase.pogressPublisher
            .sink { [weak self] (progresses) in
                self?.goalProgressSubject.send(progresses)
            }.store(in: &cancellableSet)
    }
    
    // MARK: Actions
    
    func reloadGoalsFromServer() {
        refreshStateSubject.send(.refreshing)
        //
        // Note:
        // notice. we are not reading the response
        // directly. We will eventually get it from
        // the fetchers in the usecase.
        // We only track the refresh state
        goalServiceWriter.refreshGoals()
            .sink { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    self.refreshStateSubject.send(.failed(error))
                case .finished:
                    self.refreshStateSubject.send(.succeeded)
                }
            } receiveValue: { (_) in
                // no op
            }.store(in: &cancellableSet)
    }
}

// MARK: - Extensions -

extension MyGoalsScreenInteractor: MyGoalsScreenInteractorInterface {
    
    // MARK: Information
    var date: Date {
        return currentDate
    }
    
    func goalFetching(goalId: String) -> GoalFetching {
        goalServiceReader.fetchController(goalId: goalId)
    }
    
    func goalProgressFetching(goalId: String) -> GoalProgressFetching {
        return progressServiceReader.fetchController(date: date, goalId: goalId)
    }
    
    // MARK: Publishers
    var goalsPublisher: AnyPublisher<[Goal], Never> {
        goalsSubject.eraseToAnyPublisher()
    }
    var refreshStatePublisher: AnyPublisher<MyGoalsScreenModels.RefreshState, Never> {
        refreshStateSubject.eraseToAnyPublisher()
    }
    var goalProgressPublisher: AnyPublisher<[GoalProgress], Never> {
        goalProgressSubject.eraseToAnyPublisher()
    }
    
    // MARK: Actions
    func refreshGoals() {
        self.reloadGoalsFromServer()
    }
    func setDate(date: Date) {
        setDateBuffer.send(date)
    }
}
