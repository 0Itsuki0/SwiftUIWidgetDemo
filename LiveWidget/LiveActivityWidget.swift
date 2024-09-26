//
//  LiveWidget.swift
//  LiveWidget
//
//  Created by Itsuki on 2024/09/23.
//

import WidgetKit
import SwiftUI

struct LockScreenView: View {
    
    var target: Target
    var targetStatus: EnergyAttributes.ContentState
    var isStale: Bool
    var activityId: String
    
    var body: some View {
        VStack(spacing: 16) {
            if isStale {
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                    Text("Outdated")
                    Spacer()

                }
                .foregroundStyle(.red)
                .frame(height: 16)
            }
            
            HStack {
                Image(systemName: target.customIcon)
                    .frame(minWidth: 16, minHeight: 16)
                    .aspectRatio(1, contentMode: .fit)
                
                Text("\(target.name): \(targetStatus.comment.text)")
                    .layoutPriority(100)
                    .lineLimit(1)
                
                Spacer()
                    .frame(width: 16)
                
                Button(intent: BoostIntent(activityId: activityId), label: {
                    Text("Boost!")
                        .lineLimit(1)

                })
                .foregroundStyle(.green)
                .buttonStyle(.plain)
                .padding(.vertical, 2)
                .padding(.horizontal, 8)
                .background(RoundedRectangle(cornerRadius: 4).stroke(.green, style: .init(lineWidth: 2)))
                
                Spacer()
                

            }
            .frame(height: 16)
            .padding(.horizontal, 2)
            
            EnergyBar(energyLevel: targetStatus.currentEnergyLevel, maxEnergyLevel: target.maxEnergyLevel)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .activityBackgroundTint(.white.opacity(0.8))
        .widgetURL(URL(string: "\(WidgetScheme.liveActivityWidget):///\(activityId)"))
    }
}


struct LiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: EnergyAttributes.self) { context in
            LockScreenView(target: context.attributes.target, targetStatus: context.state, isStale: context.isStale, activityId: context.activityID)
        } dynamicIsland: { context in
            return createDynamicIsland(context: context)
        }
    }
    
    func createDynamicIsland(context: ActivityViewContext<EnergyAttributes>) -> DynamicIsland {
        let target = context.attributes.target
        let targetStatus = context.state
        let padding: CGFloat = 4
        
        return DynamicIsland {

            DynamicIslandExpandedRegion(.leading) {
                HStack {
                    Image(systemName: target.customIcon)
                    Text("\(target.name)")
                        .lineLimit(1)
                }
                .frame(height: 16)
                .padding(.all, padding)
                .dynamicIsland(verticalPlacement: .belowIfTooWide)
            }
            
            DynamicIslandExpandedRegion(.trailing) {
                if context.isStale {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle")
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                        
                        Text("Outdated")

                    }
                    .foregroundStyle(.red)
                    .frame(height: 16)
                    .padding(.all, padding)

                }
            }

            DynamicIslandExpandedRegion(.bottom) {
                VStack {
                    HStack(spacing: 16) {
                        Text("\(targetStatus.comment.text)")
                            .lineLimit(1)
                            .frame(height: 16)
                        
                        
                        Button(intent: BoostIntent(activityId: context.activityID), label: {
                            Text("Boost!")
                                .lineLimit(1)

                        })
                        .foregroundStyle(.green)
                        .buttonStyle(.plain)
                        .padding(.vertical, 2)
                        .padding(.horizontal, 8)
                        .background(RoundedRectangle(cornerRadius: 4).stroke(.green, style: .init(lineWidth: 2)))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    EnergyBar(energyLevel: targetStatus.currentEnergyLevel, maxEnergyLevel: target.maxEnergyLevel, barHeight: 12)
                }
                .padding(.all, padding)
            }

        } compactLeading: {
            Text("\(target.name.uppercased().first!)")
        } compactTrailing: {
            Image(systemName: target.customIcon)
        } minimal: {
            Text("\(target.name.uppercased().first!)")
        }
        .widgetURL(URL(string: "\(WidgetScheme.liveActivityWidget):///\(context.activityID)"))

    }
}


// Lock Screen Preview
//#Preview("Notification", as: .content, using: EnergyAttributes.preview) {
//    LiveActivity()
//} contentStates: {
//    EnergyAttributes.ContentState.exhausted
//    EnergyAttributes.ContentState.fullyCharged
//}

// dynamic Island Preview
#Preview("Notification", as: .dynamicIsland(.expanded), using: EnergyAttributes.preview) {
    LiveActivity()
} contentStates: {
    EnergyAttributes.ContentState.exhausted
    EnergyAttributes.ContentState.fullyCharged
}
