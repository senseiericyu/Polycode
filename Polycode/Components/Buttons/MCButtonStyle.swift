//
//  MCButtonStyle.swift
//  Polycode
//
//  Created by Eric Yu on 4/22/25.
//


 //
//  MCButton.swift
//  Polycode
//
//  Created by Mia Yang on 4/22/25.
//

// Button style for the MC answer choices/options

import SwiftUI

struct MCButtonStyle: ButtonStyle {
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 12) {
            // Bubble indicator
            ZStack {
                Circle()
                    .stroke(lineWidth: 2)
                    .foregroundColor(isSelected ? .green : .gray)
                    .frame(width: 24, height: 24)

                if isSelected {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 12, height: 12)
                }
            }

            configuration.label
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer(minLength: 0)
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.green : Color.gray.opacity(0.4), lineWidth: 2)
        )
        .contentShape(Rectangle())
    }
}


//MARK: -View
struct MCButton: View {
    let options = ["Red", "Green", "Blue", "Yellow"]
    @State private var selectedIndex: Int? = nil
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(options.indices, id: \.self) { index in
                Button {
                    selectedIndex = index
                } label: {
                    Text(options[index])
                        .font(.body)
                }
                .buttonStyle(MCButtonStyle(isSelected: selectedIndex == index))
            }
        }
        .padding()
    }
}


#Preview {
    MCButton()
}