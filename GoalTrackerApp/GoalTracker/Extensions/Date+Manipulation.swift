//
//  Date+Manipulation.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import Foundation

extension Date {
    /// Returns a date normalized by extracting all time components
    var normalized: Date {
        let components = World.calendar.dateComponents([.year, .month, .day], from: self)
        return World.calendar.date(from: components)!
    }
    
    public var startDateInCalendar: Date {
        World.calendar.startOfDay(for: self)
    }
    
    public var endDateInCalendar: Date {
        var components = DateComponents()
        components.hour = 23
        components.minute = 59
        components.second = 59
        return World.calendar.date(byAdding: components, to: startDateInCalendar)!
    }
}
