//
//  CounterContentView.swift
//  WidgetDemo
//
//  Created by Itsuki on 2024/09/20.
//

import SwiftUI
import WidgetKit

struct CountertView: View {
    @AppStorage(CountManager.userDefaultKey, store: UserDefaults(suiteName: AppGroup.groupId)) private var count = 0
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        WrapperView() {
            Text("Your Current Count")
            HStack(spacing: 16) {
                Image(systemName: "heart.fill")
                Text("\(count)")
                Image(systemName: "heart.fill")
            }
            
            Button(action: {
                count += 1
            }, label: {
                Text("Increment!")
            })
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .foregroundStyle(.white)
            .background(RoundedRectangle(cornerRadius: 8).fill(.black))
            
            Button(action: {
                count = 0
            }, label: {
                Text("Reset!")
            })
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .foregroundStyle(.white)
            .background(RoundedRectangle(cornerRadius: 8).fill(.black))
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active || newPhase == .background {
                WidgetCenter.shared.reloadTimelines(ofKind: WidgetKind.interactiveWidget)
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
    CountertView()
}
