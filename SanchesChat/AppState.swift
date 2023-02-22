//
//  AppState.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/14.
//

import Combine

class AppState: ObservableObject {
  private let firebaseAuthManager = FirebaseAuthManager()
  private let firestoreManager = FirestoreManager()
  private var cancellable = Set<AnyCancellable>()
  
  @Published private(set) var userId: String?
  
  init() {
    observeCurrentUserId()
  }
  
  private func observeCurrentUserId() {
    firebaseAuthManager.observeCurrentUser()
      .map { $0?.uid }
      .sink { completion in
        switch completion {
        case .finished:
          debugPrint("observeCurrentUserId finished")
        case let .failure(error):
          debugPrint(error.localizedDescription)
        }
      } receiveValue: { [weak self] result in
        self?.userId = result
      }
      .store(in: &cancellable)
  }
}
