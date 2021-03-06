//
//  AppConstants.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import Foundation

public enum AppConstants {
    public static var goalsServiceBaseUrl: URL {
        if let string = Bundle.main.object(forInfoDictionaryKey: "GoalsServiceBaseUrl") as? String,
           let url = URL(string: string) {
            return url
        }
        fatalError("Missing Base URL!")
    }
}
