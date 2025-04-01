//
//  ContentView.swift
//  TranslateMe
//
//  Created by Courtney Mahugu on 4/1/25.
//

import SwiftUI

struct ContentView: View {
    @State private var inputText = ""
        @State private var outputText = ""
        @State private var sourceLang = "en"
        @State private var targetLang = "es"

        @StateObject private var viewModel = TranslationViewModel()
        private let translator = TranslatorService()

        var body: some View {
            NavigationView {
                VStack(spacing: 20) {
                    TextField("Enter text", text: $inputText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    HStack {
                        Picker("From", selection: $sourceLang) {
                            Text("English").tag("en")
                            Text("Spanish").tag("es")
                            Text("French").tag("fr")
                            Text("German").tag("de")
                        }
                        Picker("To", selection: $targetLang) {
                            Text("Spanish").tag("es")
                            Text("English").tag("en")
                            Text("French").tag("fr")
                            Text("German").tag("de")
                        }
                    }
                    .pickerStyle(MenuPickerStyle())

                    Button("Translate") {
                        translator.translate(text: inputText, from: sourceLang, to: targetLang) { result in
                            DispatchQueue.main.async {
                                outputText = result ?? "Error"
                                viewModel.saveTranslation(original: inputText, translated: outputText)
                            }
                        }
                    }

                    Text(outputText)
                        .font(.title)
                        .padding()

                    Divider()

                    HStack {
                        Text("Translation History")
                        Spacer()
                        Button("Clear") {
                            viewModel.deleteAllTranslations()
                        }
                    }
                    .padding(.horizontal)

                    List(viewModel.translations) { item in
                        VStack(alignment: .leading) {
                            Text("Original: \(item.original)")
                            Text("Translated: \(item.translated)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .navigationTitle("TranslateMe")
            }
            .onAppear {
                viewModel.fetchTranslations()
            }
        }
}

#Preview {
    ContentView()
}
