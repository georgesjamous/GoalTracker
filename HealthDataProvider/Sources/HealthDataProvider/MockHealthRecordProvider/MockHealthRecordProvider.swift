//
//  File.swift
//  
//
//  Created by Georges on 3/4/21.
//

import Foundation
import Combine

public class MockStepHealthRecordProvider: StepHealthDataProviding {
    
    private let subject = PassthroughSubject<StepHealthRecordInterface, Never>()
    
    public var recordPublisher: AnyPublisher<StepHealthRecordInterface, Never> {
        subject.eraseToAnyPublisher()
    }
  
    let date: Date
    var timer: Timer!
    
    public required init(startDate: Date, endDate: Date) {
        self.date = startDate
    }
    
    public func startLoadingRecords() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] (_) in
            self?.sendData()
        }
        timer.fire()
    }
    
    public func stopLoadingRecords() {
        
    }
    
    var count: Int = 0
    func sendData() {
        count += 8
        subject.send(StepHealthRecord(id: UUID(), date: date, stepCount: count))
    }
}

public class MockWalkingDistanceHealthRecordProvider: WalkingDistanceHealthDataProviding {
    
    private let subject = PassthroughSubject<WalkingDistanceHealthRecordInterface, Never>()
    
    public var recordPublisher: AnyPublisher<WalkingDistanceHealthRecordInterface, Never> {
        subject.eraseToAnyPublisher()
    }
    
    let date: Date
    var timer: Timer!
    
    public required init(startDate: Date, endDate: Date) {
        self.date = startDate
    }
    public func startLoadingRecords() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] (_) in
            self?.sendData()
        }
        timer.fire()
    }
    
    public func stopLoadingRecords() {
        
    }
    
    var count: Int = 0
    func sendData() {
        count += 50
        subject.send(WalkingDistanceHealthRecord(id: UUID(), date: date, distanceInMeters: count))
    }
}

public class MockRunningDistanceHealthRecordProvider: RunningDistanceHealthDataProviding {
    
    private let subject = PassthroughSubject<RunningDistanceHealthRecordInterface, Never>()
    
    public var recordPublisher: AnyPublisher<RunningDistanceHealthRecordInterface, Never> {
        subject.eraseToAnyPublisher()
    }
    
    let date: Date
    var timer: Timer!
    
    public required init(startDate: Date, endDate: Date) {
        self.date = startDate
    }
    
    public func startLoadingRecords() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] (_) in
            self?.sendData()
        }
        timer.fire()
    }
    
    public func stopLoadingRecords() {
        
    }
    
    var count: Int = 0
    func sendData() {
        count += 100
        subject.send(RunningDistanceHealthRecord(id: UUID(), date: date, distanceInMeters: count))
    }
}
