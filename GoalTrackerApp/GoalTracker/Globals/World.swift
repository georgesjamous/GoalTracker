//
//  World.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import Foundation

/// A Class representing the World.
/// We could manipulate this to change time.
public struct World {
    public static var calendar: Calendar = Calendar.autoupdatingCurrent
    public static var locale: Locale = Locale.autoupdatingCurrent
    public static var timeZone: TimeZone = TimeZone.autoupdatingCurrent
    public static var date: Date = { Date() }()
}
