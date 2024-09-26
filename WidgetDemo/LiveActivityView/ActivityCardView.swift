//
//  ActivityCardView.swift
//  WidgetDemo
//
//  Created by Itsuki on 2024/09/23.
//


import SwiftUI
import ActivityKit

struct ActivityCardView: View {
    var currentActivity: ActivityManager.ActivityStatus
    
    var body: some View {
        let target = currentActivity.target
        let targetStatus = currentActivity.contentState
        VStack(spacing: 8) {
            
            HStack {
                Image(systemName: target.customIcon)
                Text(target.name)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Comment: \(targetStatus.comment.text)")
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("Current Energy: \(String(format: "%.1f", targetStatus.currentEnergyLevel))")
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("Max Energy: \(String(format: "%.1f", target.maxEnergyLevel))")
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("Last Update: \(targetStatus.lastUpdated.formatted(date: .numeric, time: .omitted)) \(targetStatus.lastUpdated.formatted(date: .omitted, time: .shortened))")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            EnergyBar(energyLevel: targetStatus.currentEnergyLevel, maxEnergyLevel: target.maxEnergyLevel)

        }
        .foregroundStyle(.black)
        .padding()
        .fixedSize(horizontal: true, vertical: false)
        .overlay(alignment: .topTrailing, content: {
            Text("\(currentActivity.activityState.self)")
                .foregroundStyle(currentActivity.activityState == .stale ? .white : .black)
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(currentActivity.activityState == .stale ? .red.opacity(0.8) : .green)
                )
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
        })
        .background(RoundedRectangle(cornerRadius: 8).stroke(.black.opacity(0.8), style: .init(lineWidth: 1)))
    }
}

#Preview {
    ActivityCardView(
        currentActivity: ActivityManager.ActivityStatus(id: UUID().uuidString, activityState: .active, target: .testTarget, contentState: .exhausted)
    )
}
