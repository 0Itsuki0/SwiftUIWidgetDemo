//
//  StartActivityView.swift
//  WidgetDemo
//
//  Created by Itsuki on 2024/09/23.
//

import SwiftUI

enum InputField: CaseIterable {
    case name
    case currentEnergy
    case maxEnergy
}

struct StartActivityView: View {
    @EnvironmentObject private var manager: ActivityManager

    @Environment(\.dismiss) private var dismiss
    
    @State private var iconSelection: String = SFSymbol.heart
    @State private var targetName: String = "Itsuki"
    @State private var currentEnergy: Double = 0
    @State private var maxEnergy: Double = 1000
    @FocusState private var focusedInput: InputField?
    @State private var validationError: String? = nil

    var body: some View {
        WrapperView {
            if let errorMessage = manager.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
            }
            
            if let errorMessage = validationError {
                Text(errorMessage)
                    .foregroundStyle(.red)
            }
            
            Text("Define your Target!\nStart an Activity!")
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .lineSpacing(8)
            
            VStack(spacing: 12) {
                HStack {
                    Text("Custom Icon")
                        .fontWeight(.semibold)
                    Picker(selection: $iconSelection, content: {
                        ForEach(SFSymbol.list, id: \.self) { name in
                            HStack {
                                Image(systemName: name)
                                Text("\(name.self)")
                            }
                        }
                    }, label: {
                        Text("Custom Icon")
                    })
                    .pickerStyle(.menu)
                    .foregroundStyle(.black)
                    .accentColor(.black)
                }
                
                HStack {
                    Text("Target Name")
                        .fontWeight(.semibold)
                    TextField("Itsuki...", text: $targetName)
                        .focused($focusedInput, equals: .name)
                        .autocorrectionDisabled()
                        .textFieldStyle(.plain)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(.black, lineWidth: 2))
                }
                
                HStack {
                    Text("Current Energy")
                        .fontWeight(.semibold)
                    TextField(value: $currentEnergy, format: .number, label: {})
                        .focused($focusedInput, equals: .currentEnergy)
                        .autocorrectionDisabled()
                        .textFieldStyle(.plain)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(.black, lineWidth: 2))
                }
                
                HStack {
                    Text("Max Energy")
                        .fontWeight(.semibold)
                    TextField(value: $maxEnergy, format: .number, label: {})
                        .focused($focusedInput, equals: .maxEnergy)
                        .autocorrectionDisabled()
                        .textFieldStyle(.plain)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(.black, lineWidth: 2))
                    
                }
                
            }
            
            
            Spacer()
                .frame(height: 8)
            
            Button(action: {
                
                if currentEnergy > maxEnergy {
                    self.validationError = "Current energy > max!"
                    return
                }
                if targetName.isEmpty {
                    self.validationError = "Enter a name!"
                    return
                }

                let target = Target(name: targetName, customIcon: iconSelection, energyLevel: currentEnergy, maxEnergyLevel: maxEnergy)
                manager.startActivity(target: target, comment: .exhausted, staleDate: Date()+TimeInterval(60))
            }, label: {
                Text("Start Activity")
            })
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .foregroundStyle(.white)
            .background(RoundedRectangle(cornerRadius: 8).fill())
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .navigationBarBackButtonHidden(true)
        .contentShape(Rectangle())
        .onTapGesture {
            focusedInput = nil
        }
        .onChange(of: focusedInput, {
            if focusedInput != nil {
                self.validationError = nil
            }
        })
        .overlay(alignment: .topLeading, content: {
            BackButton(action: {
                dismiss()
            })
        })
        .navigationDestination(item: $manager.activityStatus, destination: { _ in
            SingleActivityView()
                .environmentObject(manager)
        })
    }
}

#Preview {
    NavigationStack {
        StartActivityView()
            .environmentObject(ActivityManager())
    }
}

