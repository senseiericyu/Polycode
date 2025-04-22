import Foundation

enum QuizType: String, Codable {
    case multipleChoice
    case writeCode
    case tokenCode
}

struct Quiz: Codable, Identifiable {
    var id: String
    var type: QuizType
    var prompt: String
    var data: QuizData
}

