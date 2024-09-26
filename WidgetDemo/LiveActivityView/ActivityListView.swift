//
//  ActivityListView.swift
//  WidgetDemo
//
//  Created by Itsuki on 2024/09/23.
//

import SwiftUI

struct ActivityListView: View {
    @State var activityId: String? = nil
    
    @EnvironmentObject private var manager: ActivityManager

    private let target = Target.testTarget
    @Environment(\.dismiss) private var dismiss


    var body: some View {
        WrapperView {
            if let errorMessage = manager.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
            }
            
            HStack(spacing: 16) {
                Text("Activity List")
                Button(action: {
                    manager.loadAllActivities()
                }, label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.caption)
                })
                .padding(.all, 6)
                .foregroundStyle(.white)
                .background(RoundedRectangle(cornerRadius: 8).fill(.black))
            }

            if manager.statusList.isEmpty {
                Text("No Activity Found!")
            } else {
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        ForEach(manager.statusList) { activityStatus in
                            Button(action: {
                                self.activityId = activityStatus.id
                            }, label: {
                                ActivityCardView(currentActivity: activityStatus)
                            })
                            .scaleEffect(0.9)
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollIndicators(.hidden)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .navigationBarBackButtonHidden(true)
        .overlay(alignment: .topLeading, content: {
            BackButton(action: {
                dismiss()
            })
        })
        .onAppear {
            manager.loadActivity(activityId)
        }
        .onChange(of: activityId, initial: true, {
            manager.setCurrentActivity(activityId)
        })
        .navigationDestination(item: $activityId, destination: { _ in
            SingleActivityView()
                .environmentObject(manager)
        })

    }
}



#Preview {
    ActivityListView()
        .environmentObject(ActivityManager())
}
