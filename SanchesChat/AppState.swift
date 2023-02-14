//
//  AppState.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/14.
//

import Combine

class AppState: ObservableObject {
  @Published private(set) var isLogIn = false
  @Published private(set) var currentUserId: String?
  private let firebaseAuthManager = FirebaseAuthManager()
  
  init() {
    observeCurrentUser()
    getCurrentUserId()
  }
  
  private func observeCurrentUser() {
    firebaseAuthManager.observeCurrentUser()
      .map { $0 != nil }
      .assign(to: &$isLogIn)
  }
  
  private func getCurrentUserId() {
    firebaseAuthManager.observeCurrentUser()
      .compactMap { $0?.uid }
      .assign(to: &$currentUserId)
  }
}
