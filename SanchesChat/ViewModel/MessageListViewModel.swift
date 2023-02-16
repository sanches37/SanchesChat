//
//  MainListViewModel.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/14.
//

import Combine

class MessageListViewModel: ObservableObject {
  private let firebaseAuthManager = FirebaseAuthManager()
  private let firestoreManager = FirestoreManager()
  private var cancellable = Set<AnyCancellable>()
  private let userId: String
  
  @Published private(set) var chatUser: ChatUser?
  
  init(userId: String) {
    self.userId = userId
    getChatUser()
  }
  
  private func getChatUser() {
    firestoreManager.getDocument(
      ChatUser.self,
      document: .users(userId: userId)
    )
      .sink { completion in
        switch completion {
        case .finished:
          debugPrint("getChatUser finished")
        case let .failure(error):
          debugPrint(error.localizedDescription)
        }
      } receiveValue: { result in
        self.chatUser = result
      }
      .store(in: &cancellable)
  }
  
  func logOut() {
    firebaseAuthManager.firebaseLogOut()
      .sink { completion in
        switch completion {
        case .finished:
          debugPrint("LogOut finished")
        case let .failure(error):
          debugPrint(error.localizedDescription)
        }
      } receiveValue: { _ in }
      .store(in: &cancellable)
  }
}
