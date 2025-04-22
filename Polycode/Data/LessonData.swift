//
//  LessonData.swift
//  Polycode
//
//  Created by Eric Yu on 4/21/25.
//

import Foundation
import FirebaseFirestore

struct LessonData: Codable, Identifiable {
    @DocumentID var id: String?
    var title: String
    var quizzes: [Quiz]
}
