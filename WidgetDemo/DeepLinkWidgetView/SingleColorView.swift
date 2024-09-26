//
//  ContentView.swift
//  WidgetDemo
//
//  Created by Itsuki on 2024/09/16.
//

import SwiftUI
import WidgetKit

struct SingleColorView: View {
    var uiColor: UIColor
    @Environment(\.dismiss) private var dismiss

    
    var body: some View {
        WrapperView {
            Text("Your Secret Color")
                .font(.title2)
            
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(uiColor: uiColor))
                .stroke(.black.opacity(0.8), style: .init(lineWidth: 2))
                .frame(width: 240, height: 160)
            
            if let rgba = uiColor.rgba {
                Text("rgba: \(rgba)")
            }
            if let hex = uiColor.hex(includeAlpha: true) {
                Text("\(hex)")
            }
        }
        .navigationBarBackButtonHidden(true)
        .overlay(alignment: .topLeading, content: {
            BackButton(action: {
                dismiss()
            })
        })
    }
}
    
#Preview {
    SingleColorView(uiColor: .red)
}
