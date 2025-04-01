//
//  TranslatorService.swift
//  TranslateMe
//
//  Created by Courtney Mahugu on 4/1/25.
//
import Foundation

class TranslatorService {
    func translate(text: String, from sourceLang: String, to targetLang: String, completion: @escaping (String?) -> Void) {
        let baseURL = "https://api.mymemory.translated.net/get"
        guard let url = URL(string: "\(baseURL)?q=\(text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&langpair=\(sourceLang)|\(targetLang)") else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            if let response = try? JSONDecoder().decode(TranslationResponse.self, from: data) {
                completion(response.responseData.translatedText)
            } else {
                completion(nil)
            }
        }.resume()
    }
}

struct TranslationResponse: Codable {
    let responseData: TranslatedData
}

struct TranslatedData: Codable {
    let translatedText: String
}

