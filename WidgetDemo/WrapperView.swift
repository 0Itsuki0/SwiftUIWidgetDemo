//
//  WrapperView.swift
//  WidgetDemo
//
//  Created by Itsuki on 2024/09/20.
//


import SwiftUI

    
struct WrapperView<Content>: View where Content: View {
    @ViewBuilder var content: Content

    var body: some View {
        let emojiStack = emojiStack()
        
        VStack(spacing: 32) {
            
            emojiStack
            
            Spacer()
            
            content

            Spacer()
            
            emojiStack
        }
        .padding(.horizontal, 64)
        .padding(.vertical, 120)

    }
    
    private func emojiStack() -> some View {
        return HStack {
            ForEach(0..<8) { _ in
                Text("🤩")
            }
        }
    }
}


#Preview {
    WrapperView() {
        Text("hey")
    }
}
