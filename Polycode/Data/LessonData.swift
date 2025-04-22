import Foundation
import FirebaseFirestore

struct LessonData: Codable, Identifiable {
    @DocumentID var id: String?
    var title: String
    var quizzes: [Quiz]
}
