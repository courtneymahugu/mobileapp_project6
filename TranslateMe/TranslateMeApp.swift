//
//  TranslateMeApp.swift
//  TranslateMe
//
//  Created by Courtney Mahugu on 4/1/25.
//

import SwiftUI
import FirebaseCore

@main
struct TranslateMeApp: App {
    init() {
            FirebaseApp.configure()
        }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
