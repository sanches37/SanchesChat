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
  @Published private(set) var chatUser: ChatUser?
  
  init() {
    observeCurrentUserId()
    getCurrentChatUser()
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
      } receiveValue: { result in
        self.userId = result
      }
      .store(in: &cancellable)
  }
  
  private func getCurrentChatUser() {
    $userId
      .compactMap { $0 }
      .flatMap {
        return self.firestoreManager
          .getDocument(ChatUser.self, document: .users(userId: $0))
      }
      .sink { completion in
        switch completion {
        case .finished:
          debugPrint("getCurrentChatUser finished")
        case let .failure(error):
          debugPrint(error.localizedDescription)
        }
      } receiveValue: { result in
        self.chatUser = result
      }
      .store(in: &cancellable)
  }
}
