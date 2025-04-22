import SwiftUI

struct MCButtonStyle: ButtonStyle {
    let isSelected: Bool
    let isCorrect: Bool?
    let isAnswered: Bool

    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .stroke(lineWidth: 2)
                    .foregroundColor(bubbleStrokeColor)
                    .frame(width: 24, height: 24)

                if isSelected {
                    Circle()
                        .fill(bubbleFillColor)
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
                .stroke(bubbleStrokeColor, lineWidth: 2)
        )
        .contentShape(Rectangle())
    }

    private var bubbleStrokeColor: Color {
        guard isSelected else { return .gray.opacity(0.4) }
        if isAnswered {
            return isCorrect == true ? Color("KiwiFill") : Color("WrongRedFill")
        } else {
            return .blue
        }
    }

    private var bubbleFillColor: Color {
        guard isSelected else { return .clear }
        if isAnswered {
            return isCorrect == true ? Color("KiwiFill") : Color("WrongRedFill")
        } else {
            return .blue
        }
    }
}
