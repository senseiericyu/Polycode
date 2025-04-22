import Foundation

enum QuestionType: String, Codable {
    case multipleChoice
    case writeCode
    case tokenCode
}

struct Question: Codable, Identifiable {
    var id: String
    var difficulty: String
    var type: QuestionType
    var prompt: String
    var data: QuestionData
}

