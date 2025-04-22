//
//  Quiz.swift
//  Polycode
//
//  Created by Eric Yu on 4/21/25.
//

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

