import SwiftUI

struct MCView: View {
    let question: String
    let options: [String]
    let correctIndex: Int
    var onAnswered: ((Bool) -> Void)? = nil

    @State private var selectedIndex: Int? = nil
    @State private var isAnswered = false
    @State private var showIncorrectModal = false
    @State private var showCorrectModal = false

    @Binding var progress: Double

    var body: some View {
        ZStack {
            VStack {
                // Progress bar
                HStack {
                    ProgressView(value: progress)
                        .tint(.green)
                        .scaleEffect(y: 3, anchor: .center)
                        .padding()
                        .animation(.easeInOut(duration: 0.25), value: progress)
                }

                Text(question)
                    .font(.title3)
                    .bold()
                    .padding(.bottom, 8)

                // Choices
                VStack(spacing: 16) {
                    ForEach(options.indices, id: \.self) { index in
                        Button {
                            selectedIndex = index
                        } label: {
                            Text(options[index])
                                .font(.body)
                        }
                        .buttonStyle(MCButtonStyle(
                            isSelected: selectedIndex == index,
                            isCorrect: (index == correctIndex),
                            isAnswered: isAnswered
                        ))
                    }
                }
                .padding()
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
                .animation(.easeOut(duration: 0.25), value: question)

                Spacer()

                // Always green check button
                Button("Check") {
                    guard let selected = selectedIndex else { return }
                    isAnswered = true

                    if selected == correctIndex {
                        showCorrectModal = true
                        progress += 1.0 / 8
                    } else {
                        showIncorrectModal = true
                    }
                }
                .buttonStyle(MainButtonStyle(
                    buttonColor: Color("KiwiFill"),
                    shadowColor: Color("KiwiShadow")
                ))
                .disabled(selectedIndex == nil)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut(duration: 0.3), value: isAnswered)
            }
            .padding()
            .onChange(of: question) {
                selectedIndex = nil
                isAnswered = false
                showCorrectModal = false
                showIncorrectModal = false
            }

            // Modals
            if showIncorrectModal {
                IncorrectModal(correctAnswer: options[correctIndex]) {
                    showIncorrectModal = false
                    onAnswered?(false)
                }
            }

            if showCorrectModal {
                CorrectModal {
                    showCorrectModal = false
                    onAnswered?(true)
                }
            }
        }
        .animation(.easeInOut, value: showIncorrectModal || showCorrectModal)
    }
}

#Preview {
    struct MCPreviewWrapper: View {
        @State private var progress: Double = 0.25

        var body: some View {
            MCView(
                question: "What case convention does Python use?",
                options: ["PascalCase", "camelCase", "snake_case", "kebab-case"],
                correctIndex: 2,
                progress: $progress
            )
        }
    }

    return MCPreviewWrapper()
}
