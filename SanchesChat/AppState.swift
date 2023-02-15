//
//  AppState.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/14.
//

import Combine

class AppState: ObservableObject {
  @Published private(set) var userId: String?
  private let firebaseAuthManager = FirebaseAuthManager()
  
  init() {
    observeCurrentUserId()
  }
  
  private func observeCurrentUserId() {
    firebaseAuthManager.observeCurrentUser()
      .map { $0?.uid }
      .assign(to: &$userId)
  }
}
