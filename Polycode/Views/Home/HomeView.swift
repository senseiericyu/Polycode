import SwiftUI
import FirebaseAuth

// MARK: - Button Position PreferenceKey

struct ButtonFrameKey: PreferenceKey {
    static var defaultValue: [Int: CGRect] = [:]
    static func reduce(value: inout [Int: CGRect], nextValue: () -> [Int: CGRect]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

struct ButtonPositionReader: ViewModifier {
    let index: Int
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geo in
                    Color.clear.preference(
                        key: ButtonFrameKey.self,
                        value: [index: geo.frame(in: .global)]
                    )
                }
            )
    }
}

struct HomeView: View {
    @State var model: LessonViewModel
    var onStartLesson: (String) -> Void

    @State private var selectedIndex: Int? = nil
    @State private var buttonFrames: [Int: CGRect] = [:]
    
    @State private var xOffsets: [Int: CGFloat] = [:]

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                Color("Backdrop").ignoresSafeArea()

                VStack(spacing: 0) {
                    TopHeader()
                        .padding(.horizontal, 18)
                        .padding(.bottom, 5)
                        .padding(.top, 15)

                    SplitHeader(
                        leftAction: { },
                        rightAction: { },
                        leftLabel: "Sections",
                        rightLabel: "⚙️",
                        buttonColor: Color("PythonBlueFill"),
                        shadowColor: Color("PythonBlueShadow")
                    )
                    .padding(.bottom, 4)

                    HomepageStepView(
                        lessons: model.lessons,
                        solvedLessonIDs: model.solvedLessonIDs,
                        onSelect: { index in
                            withAnimation {
                                selectedIndex = (selectedIndex == index) ? nil : index
                            }
                        },
                        reportOffset: { index, offset in
                            xOffsets[index] = offset
                        }
                    )
                }

                if let index = selectedIndex {
                    Rectangle()
                        .fill(Color.clear)
                        .contentShape(Rectangle())
                        .ignoresSafeArea()
                        .onTapGesture {
                            selectedIndex = nil
                        }
                        .zIndex(0.5)

                    let unlockedIndex = model.lessons.firstIndex(where: { !model.isLessonSolved($0) }) ?? model.lessons.count
                    let isUnlocked = index <= unlockedIndex

                    if index < model.lessons.count, let frame = buttonFrames[index] {
                        let lesson = model.lessons[index]
                        PathPopup(
                            text: lesson.title,
                            color: Color("PythonBlueFill"),
                            triangleOffset: xOffsets[index] ?? 0,
                            isSolved: model.isLessonSolved(lesson),
                            isUnlocked: isUnlocked,
                            onStartLesson: {
                                onStartLesson(lesson.id ?? "")
                                print("▶️ Starting lesson with id: \(lesson.id ?? "nil")")
                            }
                        )
                        .position(x: frame.midX, y: frame.maxY + 10)
                        .zIndex(1.0)
                    }
                }
            }
            .onPreferenceChange(ButtonFrameKey.self) { self.buttonFrames = $0 }
            .onAppear {
                if let uid = Auth.auth().currentUser?.uid {
                    model.loadUserAndLessons(userId: uid)
                }
            }
        }
    }
}

