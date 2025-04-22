import SwiftUI

struct QuestionView: View {
    let question: Question
    @Binding var progress: Double
    let onAnswered: (Bool) -> Void

    var body: some View {
        switch question.type {
        case .multipleChoice:
            if case .multipleChoice(let data) = question.data {
                MCView(
                    question: question.prompt,
                    options: data.choices,
                    correctIndex: data.correctIndex,
                    onAnswered: onAnswered,
                    progress: $progress
                )
            }

        case .writeCode:
            if case .writeCode(let data) = question.data {
                CodeWriteView(
                    prompt: question.prompt,
                    starterCode: data.starterCode,
                    blanks: data.blanks,
                    progress: $progress,
                    onAnswered: onAnswered
                )
            }

        case .tokenCode:
            if case .tokenCode(let data) = question.data {
                TokenView(
                    prompt: question.prompt,
                    tokens: data.tokens,
                    correctOrder: data.correctOrder,
                    progress: $progress,
                    onAnswered: onAnswered
                )
            }
        }
    }
}
