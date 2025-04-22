import SwiftUI

struct SectionView: View {
    let model: LessonViewModel
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Unit 1")
                .polyfont()
                .font(.title)

            let total = model.lessons.count
            let completed = model.lessons.filter { model.isLessonSolved($0) }.count
            let progress = total > 0 ? Double(completed) / Double(total) : 0

            VStack(alignment: .leading, spacing: 8) {
                Text("Progress")
                    .polyfont()
                    .foregroundColor(.gray)

                ProgressView(value: progress)
                    .tint(Color("KiwiFill"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .animation(.easeInOut, value: progress)

                Text("\(Int(progress * 100))% completed")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()

            Spacer()

            Button("Back") {
                onDismiss()
            }
            .buttonStyle(MainButtonStyle(buttonColor: Color("PythonBlueFill"), shadowColor: Color("PythonBlueShadow")))
        }
        .padding()
    }
}
