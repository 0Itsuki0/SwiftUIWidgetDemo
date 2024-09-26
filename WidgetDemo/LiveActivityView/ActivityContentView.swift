//
//  ActivityContentView.swift
//  WidgetDemo
//
//  Created by Itsuki on 2024/09/23.
//

import SwiftUI

struct ActivityContentView: View {
    @State var activityId: String? = nil

    @EnvironmentObject private var manager: ActivityManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        WrapperView {
            NavigationLink(destination: {
                StartActivityView()
                    .environmentObject(manager)
                
            }, label: {
                Text("Start New!")
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .foregroundStyle(.white)
                    .background(RoundedRectangle(cornerRadius: 8).fill(.black))
            })
            
            NavigationLink(destination: {
                ActivityListView()
                    .environmentObject(manager)

            }, label: {
                Text("All Activities!")
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .foregroundStyle(.white)
                    .background(RoundedRectangle(cornerRadius: 8).fill(.black))
            })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .navigationBarBackButtonHidden(true)
        .overlay(alignment: .topLeading, content: {
            BackButton(action: {
                dismiss()
            })
        })
        .navigationDestination(item: $activityId, destination: { id in
            ActivityListView(activityId: id)
                .environmentObject(manager)
        })
    }
}



#Preview {
    NavigationStack {
        ActivityContentView()
    }
}
