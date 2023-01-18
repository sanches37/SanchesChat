//
//  SanchesChatApp.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/01/18.
//

import SwiftUI
import Firebase

@main
struct SanchesChatApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
  
  private func initFirebaseSDK() {
    FirebaseApp.configure()
  }
}
