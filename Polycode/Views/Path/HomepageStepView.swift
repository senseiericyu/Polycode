//
//  HomepageStepView.swift
//  Polycode
//
//  Created by Eric Yu on 4/14/25.
//

import SwiftUI

struct HomepageStepView: View {
    let xOffsets: [CGFloat]
    let icons: [String]
    let color: String
    let onSelect: (Int) -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Spacer().frame(height: 20)

                ForEach(0..<xOffsets.count, id: \.self) { index in
                    Button {
                        onSelect(index)
                    } label: {
                        Image(systemName: icons[index])
                    }
                    .buttonStyle(PathButtonStyle(
                        buttonColor: Color("\(color)Fill"),
                        shadowColor: Color("\(color)Shadow"),
                        highlightColor: Color("\(color)Highlight")
                    ))
                    .offset(x: xOffsets[index])
                    .padding(10)
                    .modifier(ButtonPositionReader(index: index))
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    HomepageStepView(
        xOffsets: [0, -40, -60, -40, 0, 0],
        icons: ["star.fill", "star.fill", "star.fill", "star.fill", "bubbles.and.sparkles.fill", "medal.star.fill"],
        color: "Kiwi",
        onSelect: { _ in }
    )
}
