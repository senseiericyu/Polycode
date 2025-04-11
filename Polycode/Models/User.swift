//
//  User.swift
//  Polycode
//
//  Created by Eric Yu on 4/11/25.
//

import Foundation
import SwiftData

@Model
class User {
    var id: UUID
    var currentStreak: Int = 0
    var lastActiveDate: Date?
    var name: String
    var unlockedNodes: [Int] // e.g. node indices or IDs
    var completedNodes: [Int] // if you want separate tracking
    
    init(name: String, unlockedNodes: [Int] = [0], completedNodes: [Int] = []) {
        self.id = UUID()
        self.name = name
        self.unlockedNodes = unlockedNodes
        self.completedNodes = completedNodes
    }
}
