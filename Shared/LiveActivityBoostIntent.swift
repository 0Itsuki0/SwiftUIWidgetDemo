//
//  RefreshIntent.swift
//  WidgetDemo
//
//  Created by Itsuki on 2024/09/24.
//

import SwiftUI
import AppIntents

struct BoostIntent: LiveActivityIntent {
    init() {
        
    }
    
    init(activityId: String) {
        self.activityId = activityId
    }
    
    static var title: LocalizedStringResource = "Refresh Activity"
    static var description = IntentDescription("Get the newest Energy Status")
        
    @Parameter
    private var activityId: String?
    
    func perform() async throws -> some IntentResult{
        print("refreshing \(String(describing: activityId))")
        let manager = ActivityManager()
        if let activityId = activityId {
            manager.loadActivity(activityId)
            await manager.boost()
        }
        return .result()
    }
}
