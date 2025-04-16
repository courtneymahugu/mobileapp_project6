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
                guard let documents = snapshot?.documents else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                self.translations = documents.compactMap { doc in
                    let data = doc.data()
                    guard
                        let original = data["original"] as? String,
                        let translated = data["translated"] as? String,
                        let timestamp = (data["timestamp"] as? Timestamp)?.dateValue()
                    else {
                        return nil
                    }
                    
                    return Translation(id: doc.documentID, original: original, translated: translated, timestamp: timestamp)
                }
            }
    }
    func saveTranslation(original: String, translated: String) {
            let newTranslation: [String: Any] = [
                "original": original,
                "translated": translated,
                "timestamp": Date()
            ]

            db.collection("translations").addDocument(data: newTranslation)
        }

        func deleteAllTranslations() {
            db.collection("translations").getDocuments { snapshot, _ in
                snapshot?.documents.forEach { $0.reference.delete() }
            }
        }
}

