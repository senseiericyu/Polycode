//
//  QuestionsTypes.swift
//  Polycode
//
//  Created by Eric Yu on 4/11/25.
//

import Foundation

struct MCQ: Codable {
    let question: String
    let options: [String]
    let correctIndex: Int
}

struct TokenQ: Codable {
    let tokens: [String]
    let correctOrder: [String]
}

struct WriteQ: Codable {
    let question: String
    let expectedCode: String
}

struct FixQ: Codable {
    
}
