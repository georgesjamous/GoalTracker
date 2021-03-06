//
//  Date+ManipulationTests.swift
//  GoalTrackerTests
//
//  Created by Georges on 3/5/21.
//

import XCTest
@testable import GoalTracker

class DateManipulationTests: XCTestCase {

    func testDate(_ string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = World.calendar
        dateFormatter.locale = World.locale
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: string)!
    }
  
    func testMonthlyStartDate() {
        let expectedStartDate = testDate("2000-10-09 24:00:00")
        let expectedEndDate = testDate("2000-10-10 23:59:59")
        let date = testDate("2000-10-10 10:13:59")
        XCTAssertEqual(date.startDateInCalendar, expectedStartDate)
        XCTAssertEqual(date.endDateInCalendar, expectedEndDate)
    }
    
}
