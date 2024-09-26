//
//  SingleActivityView.swift
//  WidgetDemo
//
//  Created by Itsuki on 2024/09/23.
//

import SwiftUI
import ActivityKit

struct SingleActivityView: View {
    @EnvironmentObject var manager: ActivityManager
    @State private var isLoading: Bool = false
    @Environment(\.dismiss) private var dismiss


    var body: some View {
        WrapperView {
            if let errorMessage = manager.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
            }
            
            if let currentActivity = manager.activityStatus {
                ActivityCardView(currentActivity: currentActivity)

                if currentActivity.activityState != .ended && currentActivity.activityState != .dismissed {
                    
                    HStack(spacing: 24) {
                        Button(action: {
                            Task {
                                isLoading = true
                                await manager.boost()
                                isLoading = false
                            }
                            
                        }, label: {
                            Text("Energy Boost!")
                        })
                        .disabled(isLoading)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .foregroundStyle(.white)
                        .background(RoundedRectangle(cornerRadius: 8).fill())
                        
                        Button(action: {
                            Task {
                                isLoading = true

                                await manager.endActivity(dismissalPolicy: .default, comment: .full, energyLevel: currentActivity.target.maxEnergyLevel)
                                
                                isLoading = false

                            }
                        }, label: {
                            Text("End")
                        })
                        .disabled(isLoading)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .foregroundStyle(.white)
                        .background(RoundedRectangle(cornerRadius: 8).fill())

                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .navigationBarBackButtonHidden(true)
        .overlay(alignment: .topLeading, content: {
            BackButton(action: {
                dismiss()
            })
        })

        
    }
}

#Preview {
    SingleActivityView()
        .environmentObject(ActivityManager())
}
