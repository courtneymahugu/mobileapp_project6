//
//  TranslationViewModel.swift
//  TranslateMe
//
//  Created by Courtney Mahugu on 4/1/25.
//
import Foundation
import FirebaseFirestore

class TranslationViewModel: ObservableObject {
    @Published var translations = [Translation]()
    private var db = Firestore.firestore()

    func fetchTranslations() {
        db.collection("translations")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                if let docs = snapshot?.documents {
                    self.translations = docs.compactMap { try? $0.data(as: Translation.self) }
                }
            }
    }

    func saveTranslation(original: String, translated: String) {
        let newTranslation = Translation(original: original, translated: translated, timestamp: Date())
        try? db.collection("translations").addDocument(from: newTranslation)
    }

    func deleteAllTranslations() {
        db.collection("translations").getDocuments { snapshot, _ in
            snapshot?.documents.forEach { $0.reference.delete() }
        }
    }
}

