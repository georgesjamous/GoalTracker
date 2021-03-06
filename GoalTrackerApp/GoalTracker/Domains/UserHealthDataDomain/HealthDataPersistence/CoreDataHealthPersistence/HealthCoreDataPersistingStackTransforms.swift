//
//  HealthCoreDataPersistingStackTransforms.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import Foundation
import CoreData

class HealthCoreDataPersistingStackTransforms {
    @discardableResult
    func managedObjectFrom(_ record: HealthRecord, context: NSManagedObjectContext) -> HealthRecordElement {
        HealthRecordElement(context: context, record: record)
    }
    func healthRecord(object: HealthRecordElement) -> HealthRecord? {
        object.healthRecordModel
    }
    func updateRecord(object: HealthRecordElement, record: HealthRecord) {
        object.updateFrom(record: record)
    }
}

// MARK: Internals

fileprivate extension HealthRecordElement {
    convenience init(context: NSManagedObjectContext, record: HealthRecord) {
        self.init(context: context)
        updateFrom(record: record)
    }
    func updateFrom(record: HealthRecord) {
        date = record.date.normalized
        stepsTaken = Int32(record.steps)
        distanceRan = Int32(record.distanceRan)
        distanceWalked = Int32(record.distanceWalked)
    }
    var healthRecordModel: HealthRecord? {
        guard
            let date  = date
        else { return nil }
        return HealthRecord(
            // all saved elements are already normalized.
            // we will normalize again regardless
            date: date.normalized,
            steps: Int(stepsTaken),
            distanceWalked: Int(distanceWalked),
            distanceRan: Int(distanceRan)
        )
    }
}
