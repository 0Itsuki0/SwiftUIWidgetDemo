//
//  ActivityAttribute.swift
//  WidgetDemo
//
//  Created by Itsuki on 2024/09/23.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct EnergyAttributes: ActivityAttributes {
    
    enum Comment: Codable, Hashable {
        case exhausted
        case recovering
        case full
        case custom(String)
        
        var text: String {
            switch self {
            case .exhausted: return "Exhausted!"
            case .recovering: return "Recovering..."
            case .full: return "Max!"
            case .custom(let text): return text
            }
        }
    }
    
    // dynamic data
    public struct ContentState: Codable, Hashable {
        var currentEnergyLevel: Double
        var comment: Comment
        var lastUpdated: Date
    }
    
    // static data
    let target: Target
}

struct Target: Hashable, Codable, Identifiable {
    var id = UUID()
    var name: String
    var customIcon: String
    var energyLevel: Double
    var maxEnergyLevel: Double
}

extension Target {
    static var testTarget = Target(name: "itsuki", customIcon: "star.fill", energyLevel: 10, maxEnergyLevel: 10000)
}

extension EnergyAttributes {
    static var preview: EnergyAttributes {
        EnergyAttributes(target: Target.testTarget)
    }
}

extension EnergyAttributes.ContentState {
    static var exhausted: EnergyAttributes.ContentState {
        EnergyAttributes.ContentState(currentEnergyLevel: 10, comment: .exhausted,  lastUpdated: Date())
    }

    static var fullyCharged: EnergyAttributes.ContentState {
        EnergyAttributes.ContentState(currentEnergyLevel: 10000, comment: .full, lastUpdated: Date())
    }
}
