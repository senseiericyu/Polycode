import Foundation
import FirebaseFirestore
import SwiftUI

@Observable
class LessonViewModel {
    var lessons: [LessonData] = []
    var solvedLessonIDs: Set<String> = []
    private let db = Firestore.firestore()

    func loadUserAndLessons(userId: String) {
        print("🔄 loadUserAndLessons called for user: \(userId)")

        let userRef = db.collection("users").document(userId)
        userRef.getDocument { snapshot, error in
            guard let user = try? snapshot?.data(as: UserData.self) else {
                print("❌ Failed to load user: \(error?.localizedDescription ?? "unknown")")
                return
            }

            self.solvedLessonIDs = Set(user.solvedLessonIDs)
            print("✅ Loaded user with \(self.solvedLessonIDs.count) solved lessons")

            self.db.collection("lessons").getDocuments { snapshot, error in
                guard let docs = snapshot?.documents else {
                    print("❌ Failed to load lessons: \(error?.localizedDescription ?? "unknown")")
                    return
                }

                print("📚 Found \(docs.count) lesson documents")

                var loadedLessons: [LessonData] = []
                let outerGroup = DispatchGroup()

                for doc in docs {
                    guard var lesson = try? doc.data(as: LessonData.self) else {
                        print("⚠️ Failed to decode lesson from document: \(doc.documentID)")
                        continue
                    }

                    print("🧩 Lesson loaded: \(lesson.title), quizzes to fetch: \(lesson.quizIDs.count)")
                    let group = DispatchGroup()
                    var hydrated: [Question] = []

                    for id in lesson.quizIDs {
                        group.enter()
                        print("🔍 Fetching quiz ID: \(id)")

                        self.db.collection("quizzes").document(id).getDocument { qSnap, _ in
                            defer { group.leave() }
                            if let data = qSnap?.data() {
                                do {
                                    let decoded = try Firestore.Decoder().decode(Question.self, from: data)
                                    hydrated.append(decoded)
                                    print("✅ SUCCESS: Decoded question \(decoded.id)")
                                } catch {
                                    print("❌ Decode error for quiz \(id): \(error)")
                                }
                            } else {
                                print("⚠️ No quiz data for \(id)")
                            }
                        }
                    }

                    outerGroup.enter()
                    group.notify(queue: .main) {
                        lesson.quizzes = hydrated.sorted { $0.id < $1.id }
                        loadedLessons.append(lesson)
                        print("✅ Finished lesson: \(lesson.title) with \(hydrated.count) quizzes")
                        outerGroup.leave()
                    }
                }

                outerGroup.notify(queue: .main) {
                    self.lessons = loadedLessons.sorted { ($0.id ?? "") < ($1.id ?? "") }
                    print("✅ All lessons loaded: \(self.lessons.count)")
                }
            }
        }
    }

    func isLessonSolved(_ lesson: LessonData) -> Bool {
        guard let id = lesson.id else { return false }
        return solvedLessonIDs.contains(id)
    }

    func isLessonSolvedOrNext(_ lesson: LessonData) -> Bool {
        guard let lessonID = lesson.id else { return false }
        if solvedLessonIDs.contains(lessonID) { return true }
        guard let index = lessons.firstIndex(where: { $0.id == lessonID }) else { return false }
        let nextIndex = lessons.firstIndex(where: { !isLessonSolved($0) }) ?? lessons.count
        return index == nextIndex
    }

    func solvedCount(for lesson: LessonData) -> Int {
        return isLessonSolved(lesson) ? 1 : 0
    }
}
