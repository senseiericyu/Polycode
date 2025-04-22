import SwiftUI

struct TokenView: View {
    let prompt: String
    let tokens: [String]
    let correctOrder: [Int]
    @Binding var progress: Double
    let onAnswered: (Bool) -> Void

    var body: some View {
        VStack(spacing: 24) {
            ProgressView(value: progress)
                .tint(.purple)
                .scaleEffect(y: 3)
                .padding()

            Text(prompt)
                .font(.title3.bold())
                .padding()

            Text("Tokens: \(tokens.joined(separator: " "))")
                .foregroundColor(.gray)

            Spacer()

            Button("Submit") {
                onAnswered(true) // ✅ Always correct for now
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
