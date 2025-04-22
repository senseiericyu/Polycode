import Foundation
import FirebaseFirestore
import SwiftUI

@Observable
class LessonViewModel {
    var lessons: [LessonData] = []
    var solvedQuizIDs: Set<String> = []

    private let db = Firestore.firestore()

    func loadUserAndLessons(userId: String) {
        let userRef = db.collection("users").document(userId)
        userRef.getDocument { snapshot, error in
            guard let user = try? snapshot?.data(as: UserData.self) else {
                print("Failed to load user: \(error?.localizedDescription ?? "")")
                return
            }

            self.solvedQuizIDs = Set(user.solvedQuizIDs)

            self.db.collection("lessons").getDocuments { querySnapshot, error in
                guard let docs = querySnapshot?.documents else { return }
                let lessons = docs.compactMap { try? $0.data(as: LessonData.self) }
                self.lessons = lessons
            }
        }
    }

    func isLessonSolved(_ lesson: LessonData) -> Bool {
        lesson.quizzes.allSatisfy { solvedQuizIDs.contains($0.id) }
    }

    func solvedCount(for lesson: LessonData) -> Int {
        lesson.quizzes.filter { solvedQuizIDs.contains($0.id) }.count
    }
}
