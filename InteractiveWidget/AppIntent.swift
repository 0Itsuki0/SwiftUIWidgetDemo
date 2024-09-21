//
//  CountUpIntent.swift
//  WidgetDemo
//
//  Created by Itsuki on 2024/09/19.
//

import SwiftUI
import AppIntents

struct IncrementIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Increment Count"
    static var description = IntentDescription("Increment Count by 1.")
    
    func perform() async throws -> some IntentResult {
        CountManager.increment()
        return .result()
    }
}


struct ResetIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Reset Count"
    static var description = IntentDescription("Reset Count to 0.")
    
    func perform() async throws -> some IntentResult {
        CountManager.reset()
        return .result()
    }
}
