import FirebaseAuth
import FirebaseFirestore
import SwiftUI

@Observable
class LessonViewModel {
    @MainActor var loggedDates: [Date] = []
    var streak: Int = 0

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
        
            Task { @MainActor in
                self.loggedDates = user.lastLogged
            }
            
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

                    lesson.id = doc.documentID
                    print("🧩 Lesson loaded: \(lesson.title) — ID: \(lesson.id ?? "nil")")

                    let group = DispatchGroup()
                    var hydrated: [Question] = []

                    for id in lesson.quizIDs {
                        group.enter()
                        print("🔍 Fetching quiz ID: \(id)")

                        self.db.collection("quizzes").document(id).getDocument { qSnap, _ in
                            defer { group.leave() }
                            guard let data = qSnap?.data() else {
                                print("⚠️ No quiz data for \(id)")
                                return
                            }

                            do {
                                let decoded = try Firestore.Decoder().decode(Question.self, from: data)
                                hydrated.append(decoded)
                                print("✅ SUCCESS: Decoded question \(decoded.id)")
                            } catch {
                                print("❌ Decode error for quiz \(id): \(error)")
                            }
                        }
                    }

                    outerGroup.enter()
                    group.notify(queue: .main) {
                        lesson.quizzes = hydrated.sorted { $0.id < $1.id }
                        print("✅ Finished lesson: \(lesson.title) with \(hydrated.count) quizzes")
                        loadedLessons.append(lesson)
                        outerGroup.leave()
                    }
                }

                outerGroup.notify(queue: .main) {
                    self.lessons = loadedLessons.sorted { ($0.id ?? "") < ($1.id ?? "") }
                    print("✅ All lessons loaded: \(self.lessons.count)")
                    for l in self.lessons {
                        print(" - \(l.id ?? "nil"): \(l.title)")
                    }
                }
            }
        }
    }

    func markLessonSolved(_ lessonID: String) {
        print("✅ Marking lesson as solved: \(lessonID)")
        solvedLessonIDs.insert(lessonID)
        if let user = Auth.auth().currentUser {
            db.collection("users").document(user.uid).updateData([
                "solvedLessonIDs": FieldValue.arrayUnion([lessonID])
            ]) { error in
                if let error = error {
                    print("❌ Failed to mark lesson as solved: \(error)")
                } else {
                    print("🧾 Firestore updated with solved lesson \(lessonID)")
                }
            }
        }
    }

    func isLessonSolved(_ lesson: LessonData) -> Bool {
        guard let id = lesson.id else { return false }
        return solvedLessonIDs.contains(id)
    }
    
    func logTodayIfNeeded(for userId: String) {
        let today = Calendar.current.startOfDay(for: Date())
        
        db.collection("users").document(userId).getDocument { snapshot, _ in
            guard let data = snapshot?.data(),
                  let existingDates = data["lastLogged"] as? [Timestamp] else {
                // First time logging in, write new array
                self.db.collection("users").document(userId).updateData([
                    "lastLogged": [Timestamp(date: today)]
                ])
                return
            }

            let alreadyLoggedToday = existingDates.contains { ts in
                Calendar.current.isDate(ts.dateValue(), inSameDayAs: today)
            }

            if !alreadyLoggedToday {
                self.db.collection("users").document(userId).updateData([
                    "lastLogged": FieldValue.arrayUnion([Timestamp(date: today)])
                ]) { error in
                    if let error = error {
                        print("❌ Failed to log today: \(error)")
                    } else {
                        print("🔥 Logged today's date!")
                    }
                }
            }
        }
    }
}
