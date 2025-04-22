import SwiftUI

struct LessonView: View {
    let lesson: LessonData
    let model: LessonViewModel
    let onComplete: () -> Void

    @State private var currentIndex = 0
    @State private var correctCount = 0
    @State private var progress: Double = 0.0

    var body: some View {
        if currentIndex < lesson.quizzes.count {
            QuestionView(
                question: lesson.quizzes[currentIndex],
                progress: $progress
            ) { isCorrect in
                if isCorrect { correctCount += 1 }
                currentIndex += 1
                progress = Double(currentIndex) / Double(lesson.quizzes.count)
            }
        } else {
            VStack(spacing: 20) {
                Text("Lesson Complete!")
                    .polyfont()
                    .font(.title)
                    .bold()
                Text("You got \(correctCount) out of \(lesson.quizzes.count) correct.")
                    .polyfont()
                Button("Finish") {
                    if correctCount == lesson.quizzes.count,
                       let id = lesson.id {
                        model.markLessonSolved(id)
                    }
                    onComplete()
                }
                .polyfont()
                .buttonStyle(MainButtonStyle(buttonColor:(Color("PythonBlueFill")), shadowColor: Color("PythonBlueShadow")))
                .foregroundStyle(Color.white)
            }
            .padding()
        }
    }
}
