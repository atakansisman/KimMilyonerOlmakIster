// Models/Question.swift

import Foundation

struct Question: Codable {
    let pool: Int
    let questionText: String
    let options: [String]
    let correctIndex: Int
}
