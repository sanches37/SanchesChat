//
//  ContentView.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/18.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject var appState: AppState
  
  var body: some View {
    if let userId = appState.userId {
      MessageListView(userId: userId)
    } else {
      LogInView()
    }
  }
}
