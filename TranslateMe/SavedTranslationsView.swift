//
//  SavedTranslationsView.swift
//  TranslateMe
//
//  Created by Courtney Mahugu on 4/16/25.
//
import SwiftUI

struct SavedTranslationsView: View {
    @ObservedObject var viewModel: TranslationViewModel

    var body: some View {
        List(viewModel.translations) { translation in
            VStack(alignment: .leading) {
                Text("Original: \(translation.original)")
                    .font(.headline)
                Text("Translated: \(translation.translated)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle("Saved Translations")
        .toolbar {
            Button("Clear All") {
                viewModel.deleteAllTranslations()
            }
        }
        .onAppear {
            viewModel.fetchTranslations()
        }
    }
}

