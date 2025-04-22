//
//  File.swift
//  Polycode
//
//  Created by Eric Yu on 4/21/25.
//

import Foundation
import FirebaseFirestore

struct UserData: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var email: String
    var streak: Int
    var lastLogged: Date
    var createdAt: Date
}
