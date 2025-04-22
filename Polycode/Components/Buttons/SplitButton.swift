//
//  SplitButton.swift
//  Polycode
//
//  Created by Eric Yu on 4/15/25.
//

import SwiftUI


struct SplitButtonStyle: ButtonStyle {
    let buttonColor: Color
    let shadowColor: Color
    let corners: UIRectCorner

    func makeBody(configuration: Configuration) -> some View {
        RoundedCorner(radius: 12, corners: corners)
            .fill(buttonColor)
            .overlay(
                configuration.label
                    .polyfont()
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            )
            .clipShape(RoundedCorner(radius: 12, corners: corners))
            .shadow(color: shadowColor, radius: 0, y: configuration.isPressed ? 0 : 4)
            .offset(y: configuration.isPressed ? 4 : 0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

//helper method for asymmetrical rounded corners on the double button
struct RoundedCorner: Shape {
    var radius: CGFloat = 12
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

//MARK: -View
struct SplitButton: View {
    var body: some View {
        Button(action: {}) {
            Text("action")
                .font(.system(size: 35))
                .frame(maxHeight: .infinity)
        }
        .buttonStyle(SplitButtonStyle(
            buttonColor: Color("KiwiFill"),
            shadowColor: Color("KiwiShadow"),
            corners: [.topLeft, .bottomLeft]
        ))
        .frame(height: 80)
        .padding(.horizontal, 16)
        
        Button(action: {}) {
            Text("action")
                .font(.system(size: 35))
                .frame(maxHeight: .infinity)
        }
        .buttonStyle(SplitButtonStyle(
            buttonColor: Color("KiwiFill"),
            shadowColor: Color("KiwiShadow"),
            corners: [.topRight, .bottomRight]
        ))
        .frame(height: 80)
        .padding(.horizontal, 16)
    }
}

#Preview {
    SplitButton()
}
