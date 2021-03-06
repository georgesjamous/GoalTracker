//
//  AppleHealthDataProvider.swift
//  GoalTrackerTests
//
//  Created by Georges on 3/5/21.
//

import XCTest
@testable import GoalTracker
import HealthDataProvider
import HealthKit
import Combine

// Note:
// since i didnt implement the Edit Health Data (Adding Health kit data on the go)
// it is impossible (to my knowlege) to test apple healh kit integration without it.
// to echk if the libarray is working properly.
// So this only tests some cases and the rest need to be tested manually (for now)

