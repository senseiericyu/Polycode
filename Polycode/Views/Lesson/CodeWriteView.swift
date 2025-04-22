import SwiftUI

struct CodeWriteView: View {
    let prompt: String
    let starterCode: String
    let blanks: [String]
    @Binding var progress: Double
    let onAnswered: (Bool) -> Void

    @State private var userAnswers: [String] = []
    @State private var showCorrectModal = false
    @State private var showIncorrectModal = false
    @State private var isAnswered = false

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                // Progress
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
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)

                // Fill-in Code Layout
                VStack(alignment: .leading, spacing: 14) {
                    let parts = starterCode.components(separatedBy: "___")
                    ForEach(0..<blanks.count, id: \.self) { index in
                        HStack(alignment: .center, spacing: 6) {
                            if index < parts.count {
                                Text(parts[index])
                                    .font(.system(.body, design: .monospaced))
                                    .foregroundColor(.gray)
                            }

                            TextField("...", text: Binding(
                                get: { index < userAnswers.count ? userAnswers[index] : "" },
                                set: { newValue in
                                    if index < userAnswers.count {
                                        userAnswers[index] = newValue
                                    }
                                }
                            ))
                            .polyfont()
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.15)))
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.4)))
                            .textInputAutocapitalization(.never)
                        }
                    }

                    if parts.count > blanks.count {
                        Text(parts.last!)
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)

                Spacer()

                // Check Button
                if userAnswers.allSatisfy({ !$0.isEmpty }) {
                    Button("Check") {
                        let correct = userAnswers.elementsEqual(blanks, by: { $0.trimmingCharacters(in: .whitespaces) == $1 })
                        isAnswered = true
                        if correct {
                            progress += 1.0 / 8
                            showCorrectModal = true
                        } else {
                            showIncorrectModal = true
                        }
                    }
                    .buttonStyle(MainButtonStyle(
                        buttonColor: Color("KiwiFill"),
                        shadowColor: Color("KiwiShadow")
                    ))
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.easeInOut(duration: 0.25), value: userAnswers)
                    .padding(.horizontal)
                }
            }
            .padding(.bottom, 24)
            .onAppear {
                userAnswers = Array(repeating: "", count: blanks.count)
            }
            .onChange(of: prompt) {
                // Reset state when question changes
                userAnswers = Array(repeating: "", count: blanks.count)
                isAnswered = false
                showCorrectModal = false
                showIncorrectModal = false
            }

            // Modals
            if showCorrectModal {
                CorrectModal {
                    showCorrectModal = false
                    onAnswered(true)
                }
            }

            if showIncorrectModal {
                IncorrectModal(correctAnswer: blanks.joined(separator: ", ")) {
                    showIncorrectModal = false
                    onAnswered(false)
                }
            }
        }
        .animation(.easeInOut, value: showCorrectModal || showIncorrectModal)
    }
}
