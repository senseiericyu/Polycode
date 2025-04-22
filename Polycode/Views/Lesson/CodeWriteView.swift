import SwiftUI

struct CodeWriteView: View {
    let prompt: String
    let starterCode: String
    let blanks: [String]
    @Binding var progress: Double
    let onAnswered: (Bool) -> Void

    var body: some View {
        VStack(spacing: 24) {
            ProgressView(value: progress)
                .tint(.blue)
                .scaleEffect(y: 3)
                .padding()

            Text(prompt)
                .font(.title3.bold())
                .padding(.top)

            Text("Starter Code:")
                .font(.caption)
            TextEditor(text: .constant(starterCode))
                .frame(height: 150)
                .border(Color.gray)

            Spacer()

            Button("Submit") {
                onAnswered(true) // ✅ Always correct for now
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
