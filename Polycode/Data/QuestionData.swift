import Foundation
import FirebaseFirestore

enum QuestionData: Codable {
    case multipleChoice(MultipleChoiceData)
    case writeCode(CodeWriteData)
    case tokenCode(TokenCodeData)

    private enum CodingKeys: String, CodingKey {
        case type
        case value
    }

    private enum DataType: String, Codable {
        case multipleChoice
        case writeCode
        case tokenCode
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(DataType.self, forKey: .type)

        switch type {
        case .multipleChoice:
            let data = try container.decode(MultipleChoiceData.self, forKey: .value)
            self = .multipleChoice(data)
        case .writeCode:
            let data = try container.decode(CodeWriteData.self, forKey: .value)
            self = .writeCode(data)
        case .tokenCode:
            let data = try container.decode(TokenCodeData.self, forKey: .value)
            self = .tokenCode(data)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .multipleChoice(let data):
            try container.encode(DataType.multipleChoice, forKey: .type)
            try container.encode(data, forKey: .value)
        case .writeCode(let data):
            try container.encode(DataType.writeCode, forKey: .type)
            try container.encode(data, forKey: .value)
        case .tokenCode(let data):
            try container.encode(DataType.tokenCode, forKey: .type)
            try container.encode(data, forKey: .value)
        }
    }
}

struct MultipleChoiceData: Codable {
    let choices: [String]
    let correctIndex: Int
}

struct CodeWriteData: Codable {
    let starterCode: String
    let blanks: [String]
}

struct TokenCodeData: Codable {
    let tokens: [String]       // e.g. ["def", "myFunc", "(", ")", ":"]
    let correctOrder: [Int]    // e.g. [0, 1, 2, 3, 4]
}
