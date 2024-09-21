//
//  CountManager.swift
//  WidgetDemo
//
//  Created by Itsuki on 2024/09/19.
//


import SwiftUI

class CountManager {
    static let userDefaultKey = "InteractiveWidgetCount"
    static let userDefaults = UserDefaults(suiteName: AppGroup.groupId) ?? UserDefaults.standard
    
    static func increment() {
        print("increment")
        userDefaults.set(currentCount + 1, forKey: userDefaultKey)
    }
    
    static func reset() {
        userDefaults.set(0, forKey: userDefaultKey)
    }
    
    static var currentCount: Int {
        return userDefaults.integer(forKey: userDefaultKey)
    }
}

