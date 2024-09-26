//
//  BackButton.swift
//  WidgetDemo
//
//  Created by Itsuki on 2024/09/23.
//

import SwiftUI

struct BackButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Text("Back")
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .foregroundStyle(.black)
                .background(RoundedRectangle(cornerRadius: 8)
                    .fill(.gray.opacity(0.1))
                    .stroke(.black, style: .init(lineWidth: 1)))
        })
        .padding(.horizontal, 8)
        .padding(.vertical, 24)

    }
}
