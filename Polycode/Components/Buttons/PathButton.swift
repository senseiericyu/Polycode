//
//  PathButton.swift
//  Polycode
//
//  Created by Eric Yu on 4/15/25.
//

import SwiftUI

struct PathButtonStyle: ButtonStyle {
    let buttonColor: Color
    let shadowColor: Color
    
    let highlightColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: 30, maxHeight: 20)
            .padding()
            .background(
                ZStack {
                    buttonColor
                    Ellipse()
                        .fill(.clear)
                        .overlay(
                            ZStack {
                                HStack(spacing: 8) {
                                    Rectangle()
                                        .fill(highlightColor)
                                        .frame(width: 10)
                                    
                                    Rectangle()
                                        .fill(highlightColor)
                                        .frame(width: 20)
                                }
                                .frame(height: 50)
                                .offset(x: -5)
                                .rotationEffect(.degrees(40))
                            }
                        )
                    Ellipse()
                        .strokeBorder(buttonColor, lineWidth: 5)
                    
                }
            )
            .clipShape(.ellipse)
            .foregroundStyle(.white)
            .shadow(color: shadowColor, radius: 0, y: configuration.isPressed ? 0 : 5.5)
            .offset(y: configuration.isPressed ? 4 : 0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

//MARK: -View
struct PathButton: View {
    var body: some View {
        Button {} label: {
            Image(systemName: "star.fill")
        }
        .buttonStyle(PathButtonStyle(
            buttonColor: Color("VictoryGoldFill"),
            shadowColor: Color("VictoryGoldShadow"),
            highlightColor: Color("VictoryGoldHighlight")
        ))
        
    }
}

#Preview {
    PathButton()
}
