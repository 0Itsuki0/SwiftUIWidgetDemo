//
//  ActivityManager.swift
//  WidgetDemo
//
//  Created by Itsuki on 2024/09/23.
//

import SwiftUI
import ActivityKit

class ActivityManager: ObservableObject {
    
    struct ActivityStatus: Sendable, Hashable, Identifiable {
        var id: String
        var activityState: ActivityState
        var target: Target
        var contentState: EnergyAttributes.ContentState
        
        init(id: String, activityState: ActivityState, target: Target, contentState: EnergyAttributes.ContentState) {
            self.id = id
            self.activityState = activityState
            self.target = target
            self.contentState = contentState
        }
        
        init(activity: Activity<EnergyAttributes>) {
            self.id = activity.id
            self.activityState = activity.activityState
            self.target = activity.attributes.target
            self.contentState = activity.content.state
        }
    }
    
    // current Activity
    @Published var activityStatus: ActivityStatus? = nil
    private var observationTaskSingle: Task<Void, Error>?

    private var currentActivity: Activity<EnergyAttributes>? {
        didSet {
            self.observationTaskSingle?.cancel()
            DispatchQueue.main.async {
                if let activity = self.currentActivity {
                    self.activityStatus = ActivityStatus(activity: activity)
                    self.observeSingleActivity(activity)
                    
                } else {
                    self.activityStatus = nil
                }
            }
        }
    }
    @Published var statusList: [ActivityStatus] = []
    private var observationTaskMulti: Task<Void, Error>?
    private var activityList: [Activity<EnergyAttributes>] = [] {
        didSet {
            DispatchQueue.main.async {
                self.statusList = self.activityList.map({ActivityStatus(activity: $0)})
            }
        }
    }
    @Published var errorMessage: String? = nil
    
    
    func loadAllActivities() {
        self.activityList = Activity<EnergyAttributes>.activities
    }
    
    func setCurrentActivity(_ activityId: String?) {
        if let id = activityId {
            self.currentActivity = activityList.first(where: {$0.id == id})
        } else {
            self.currentActivity = nil
        }
    }
    
    
    func loadActivity(_ activityId: String?) {
        DispatchQueue.main.async {
            self.errorMessage = nil
        }

        self.currentActivity = nil
        loadAllActivities()

        guard let activityId = activityId else {
            return
        }
        
        guard let activity = self.activityList.first(where: {$0.id == activityId}) else {
            self.errorMessage = "No Activity Found for current Target!"
            return
        }
        if activity.activityState == .ended || activity.activityState == .dismissed {
            self.errorMessage = "Activity is Ended! Please start a new one!"
            return
        }
        
        self.currentActivity = activity
    }

    
    func startActivity(target: Target, comment: EnergyAttributes.Comment, staleDate: Date? = nil) {
        DispatchQueue.main.async {
            self.errorMessage = nil
        }
        
        if ActivityAuthorizationInfo().areActivitiesEnabled {
            do {
                let currentDate = Date()
                
                let attributes = EnergyAttributes(target: target)
                let contentState = EnergyAttributes.ContentState(currentEnergyLevel: target.energyLevel, comment: comment, lastUpdated: currentDate)

                let activity = try Activity.request(
                    attributes: attributes,
                    content: .init(state: contentState, staleDate: staleDate),
                    pushType: nil
                )
                print("activity started")
                print(activity)
                
                self.currentActivity = activity

            } catch(let error) {
                self.errorMessage = "Fail to start. Error: \(error)"
            }
        } else {
            self.errorMessage = "Live Activity not enabled!"
        }
    }
    
    func updateActivity(comment: EnergyAttributes.Comment, newEnergyLevel: Double, staleDate: Date? = nil) async {
        DispatchQueue.main.async {
            self.errorMessage = nil
        }
        guard let currentActivity = currentActivity else {
            self.errorMessage = "Start a New activity or load an existing one before update."
            return
        }

        let target = currentActivity.attributes.target
        
        let currentDate = Date()
        let contentState = EnergyAttributes.ContentState(currentEnergyLevel: newEnergyLevel, comment: comment, lastUpdated: currentDate)

        let name = target.name
        let alertBody: LocalizedStringResource = if newEnergyLevel >= target.maxEnergyLevel {
            "\(name) is fully charged!"
        } else if (newEnergyLevel <= 0) {
            "\(name) is down..."
        } else {
            "\(name) is at \(newEnergyLevel)"
        }
        
        let alertConfiguration = AlertConfiguration(
            title: "Energy Update!",
            body: alertBody,
            sound: .default
        )
        
        await currentActivity.update(
            ActivityContent<EnergyAttributes.ContentState>(
                state: contentState,
                staleDate: staleDate
            ),
            alertConfiguration: alertConfiguration
        )
        
        if newEnergyLevel >= target.maxEnergyLevel {
            let policy: ActivityUIDismissalPolicy = if let staleDate = staleDate {
                .after(staleDate)
            } else {
                .default
            }
            await self.endActivity(dismissalPolicy: policy, comment: comment, energyLevel: newEnergyLevel)
        }

    }
    
    func endActivity(dismissalPolicy: ActivityUIDismissalPolicy, comment: EnergyAttributes.Comment, energyLevel: Double) async {
        DispatchQueue.main.async {
            self.errorMessage = nil
        }

        guard let currentActivity = currentActivity else {
            self.errorMessage = "Start a New activity or load an existing one before ending it."
            return
        }

        let currentDate = Date()
        let finalState = EnergyAttributes.ContentState(currentEnergyLevel: energyLevel, comment: comment, lastUpdated: currentDate)
        await currentActivity.end(ActivityContent(state: finalState, staleDate: nil), dismissalPolicy: dismissalPolicy)
    }
    
    
    func observeSingleActivity(_ activity: Activity<EnergyAttributes>) {
        self.observationTaskSingle?.cancel()
        self.observationTaskSingle = Task {
            await withTaskGroup(of: Void.self) { group in
                group.addTask { @MainActor in
                    for await activityState in activity.activityStateUpdates {
                        print("activityStateUpdates: \(activityState)")
                        self.activityStatus?.activityState = activityState
                    }
                }
                
                group.addTask { @MainActor in
                    for await contentState in activity.contentUpdates {
                        print("contentState update: \(contentState)")
                        self.activityStatus?.contentState = contentState.state
                    }
                }
            }
        }
    }
    
    func observeActivityList() {
        self.observationTaskMulti?.cancel()
        self.observationTaskMulti = Task { @MainActor in
            for await activity in Activity<EnergyAttributes>.activityUpdates {
                print("activityUpdates: \(activity)")
                self.activityList.append(activity)
            }
        }
    }
}



// helper functions for intent actions
extension ActivityManager {
    
    func boost() async {
        guard let currentActivity = currentActivity else {
            self.errorMessage = "Start a New activity or load an existing one before update."
            return
        }
        let target = currentActivity.attributes.target

        let previousState = currentActivity.content.state
        let previousEnergyLevel = previousState.currentEnergyLevel
        
        let randomBoost = Int.random(in: 0...Int(target.maxEnergyLevel-previousEnergyLevel))
        
        await self.updateActivity(comment: .custom("Boost by \(randomBoost)!"), newEnergyLevel: previousEnergyLevel+Double(randomBoost), staleDate: nil)
    }
}
