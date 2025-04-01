//
//  Translation.swift
//  TranslateMe
//
//  Created by Courtney Mahugu on 4/1/25.
//
import Foundation
import FirebaseFirestore

struct Translation: Identifiable, Codable {
    @DocumentID var id: String?
    var original: String
    var translated: String
    var timestamp: Date
}

