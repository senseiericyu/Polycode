import Foundation
import Firebase
import FirebaseFirestore

struct LessonData: Codable, Identifiable {
    @DocumentID var id: String?
    var title: String
    var quizIDs: [String]
    var quizzes: [Question] = [] // this is local only

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case quizIDs
        // exclude quizzes so Firestore doesn't try to decode it
    }
}
