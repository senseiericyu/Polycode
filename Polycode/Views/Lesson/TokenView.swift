import SwiftUI

struct TokenView: View {
    let prompt: String
    let tokens: [String]
    let correctOrder: [Int]
    @Binding var progress: Double
    let onAnswered: (Bool) -> Void

    @State private var shuffledTokens: [String] = []
    @State private var placedTokens: [String] = []
    @State private var showCorrectModal = false
    @State private var showIncorrectModal = false
    @State private var isAnswered = false

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                // Progress Bar
                HStack {
                    Spacer()
                    ProgressView(value: progress)
                        .tint(Color("KiwiFill"))
                        .scaleEffect(y: 3)
                        .padding()
                }

                // Prompt
                Text(prompt)
                    .font(.title3.bold())
                    .padding(.horizontal)

                // Placed Tokens
                VStack(spacing: 8) {
                    WrapStack(data: placedTokens) { token in
                        Text(token)
                            .polyfont()
                            .foregroundColor(.black)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.4))
                            )
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    placedTokens.removeAll { $0 == token }
                                }
                            }
                            .transition(.scale.combined(with: .opacity))
                    }
                    .animation(.easeInOut(duration: 0.25), value: placedTokens)
                }

                Spacer()

                // Available Tokens
                VStack(spacing: 12) {
                    WrapStack(data: shuffledTokens.filter { !placedTokens.contains($0) }) { token in
                        Button {
                            withAnimation(.easeOut(duration: 0.15)) {
                                placedTokens.append(token)
                            }
                        } label: {
                            Text(token)
                                .polyfont()
                                .foregroundColor(.white)
                        }
                        .buttonStyle(MainButtonStyle(
                            buttonColor: Color("PythonBlueFill"),
                            shadowColor: Color("PythonBlueShadow")
                        ))
                        .transition(.scale.combined(with: .opacity))
                    }
                    .animation(.easeInOut(duration: 0.25), value: placedTokens)
                }

                // Check Button
                if placedTokens.count == tokens.count {
                    Button("Check") {
                        let expected = correctOrder.map { tokens[$0] }
                        let correct = expected == placedTokens
                        if correct { progress += 1.0 / 8 }

                        isAnswered = true
                        correct ? (showCorrectModal = true) : (showIncorrectModal = true)
                    }
                    .buttonStyle(MainButtonStyle(
                        buttonColor: Color("KiwiFill"),
                        shadowColor: Color("KiwiShadow")
                    ))
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.easeOut(duration: 0.15), value: placedTokens)
                    .padding(.horizontal)

                }
            }
            .padding(.horizontal)
            .padding(.bottom, 24)

            // Modals
            if showCorrectModal {
                CorrectModal {
                    showCorrectModal = false
                    onAnswered(true)
                }
            }

            if showIncorrectModal {
                IncorrectModal(correctAnswer: correctOrder.map { tokens[$0] }.joined(separator: " ")) {
                    showIncorrectModal = false
                    onAnswered(false)
                }
            }
        }
        .onAppear {
            shuffledTokens = tokens.shuffled()
        }
        .onChange(of: prompt) {
            withAnimation(.easeOut(duration: 0.2)) {
                shuffledTokens = tokens.shuffled()
                placedTokens = []
                isAnswered = false
                showCorrectModal = false
                showIncorrectModal = false
            }
        }
        .animation(.easeInOut, value: showCorrectModal || showIncorrectModal)
    }
}
