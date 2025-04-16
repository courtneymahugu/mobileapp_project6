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
    
    @State private var showSavedTranslations = false


    @StateObject private var viewModel = TranslationViewModel()
    private let translator = TranslatorService()

    var body: some View {
        NavigationStack {
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
                            
                            // ✅ Automatically save the translation
                            if let translated = result, !translated.isEmpty {
                                viewModel.saveTranslation(original: inputText, translated: translated)
                            }
                        }
                    }
                }

                Text(outputText)
                    .font(.title)
                    .padding()

                Spacer()

                Button("View Saved Translations") {
                    showSavedTranslations = true
                }
                .navigationDestination(isPresented: $showSavedTranslations) {
                    SavedTranslationsView(viewModel: viewModel)
                }
                .padding()
    
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
