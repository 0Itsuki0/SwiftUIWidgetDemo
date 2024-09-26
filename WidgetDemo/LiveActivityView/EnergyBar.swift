//
//  EnergyBar.swift
//  WidgetDemo
//
//  Created by Itsuki on 2024/09/25.
//

import SwiftUI

struct EnergyBar: View {
    var energyLevel: Double
    var maxEnergyLevel: Double
    
    var barHeight: CGFloat = 16
    
    var body: some View {
        let percentage = max(min(energyLevel / maxEnergyLevel, 1), 0)

        HStack(spacing: 4) {
            Image(systemName: "heart.fill")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .minimumScaleFactor(0.5)
                .foregroundStyle(Color.red, Color.white)
            
            GeometryReader { geometry in
                let frame = geometry.frame(in: .local)
                let boxWidth = frame.width * percentage
                
                RoundedRectangle(cornerRadius: 4)
                    .foregroundStyle(Color.gray)
                
                RoundedRectangle(cornerRadius: 4)
                    .frame(width: boxWidth)
                    .foregroundStyle(Color.green)
            }
            .frame(height: 10)

            Text("\(Int(percentage * 100))%")
                .minimumScaleFactor(0.5)

        }
        .frame(height: barHeight)
    }
}
