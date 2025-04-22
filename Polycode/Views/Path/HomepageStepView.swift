import SwiftUI

struct HomepageStepView: View {
    
    let lessons: [LessonData]
    let solvedLessonIDs: Set<String>
    let onSelect: (Int) -> Void
    
    let baseColors = ["PythonBlue"]
    
    let reportOffset: (Int, CGFloat) -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Spacer().frame(height: 20)
                
                ForEach(lessons.indices, id: \.self) { index in
                    let lesson = lessons[index]
                    let isSolved = lesson.id.map { solvedLessonIDs.contains($0) } ?? false
                    let colorKey = baseColors[index % baseColors.count]
                    let iconName = iconForIndex(index)
                    
                    let buttonColor = isSolved ? Color("\(colorKey)Fill") : Color("LockedGrayFill")
                    let shadowColor = isSolved ? Color("\(colorKey)Shadow") : Color("LockedGrayShadow")
                    let highlightColor = isSolved ? Color("\(colorKey)Highlight") : Color("LockedGrayFill")
                    
                    
                    Button {
                        onSelect(index)
                    } label: {
                        Image(systemName: iconName)
                    }
                    .buttonStyle(PathButtonStyle(
                        buttonColor: buttonColor,
                        shadowColor: shadowColor,
                        highlightColor: highlightColor
                    ))
                    .offset(x: offsetForIndex(index))
                    .onAppear {
                        reportOffset(index, offsetForIndex(index))
                    }
                    .padding(10)
                    .modifier(ButtonPositionReader(index: index))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 20)
        }
    }
    
    func offsetForIndex(_ index: Int) -> CGFloat {
        let pattern: [CGFloat] = [0, -40, -60, -40, 0, 0]
        return pattern[index % pattern.count]
    }
    
    func iconForIndex(_ index: Int) -> String {
        let icons = [
            "star.fill",
            "star.fill",
            "star.fill",
            "star.fill",
            "bubbles.and.sparkles.fill",
            "medal.star.fill"
        ]
        return icons[index % icons.count]
    }
}


#Preview {
    HomepageStepView(
        lessons: [
            LessonData(id: "lesson1", title: "Intro to Variables", quizIDs: ["python-1-1-1"], quizzes: [
                Question(id: "python-1-1-1", difficulty: "easy", type: .multipleChoice, prompt: "What is 2 + 2?", data: .multipleChoice(MultipleChoiceData(choices: ["3", "4", "5"], correctIndex: 1)))
            ]),
            LessonData(id: "lesson2", title: "Functions", quizIDs: ["python-1-1-2"], quizzes: [
                Question(id: "python-1-1-2", difficulty: "easy", type: .writeCode, prompt: "Write a function", data: .writeCode(CodeWriteData(starterCode: "def ___(x): return x", blanks: ["func"])))
            ])
        ],
        solvedLessonIDs: ["lesson1"],
        onSelect: { _ in },
        reportOffset: { _, _ in }
    )
}

