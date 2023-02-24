//
//  NewMessageViewModel.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/17.
//

import Combine

class NewMessageViewModel: ObservableObject {
  private let firestoreManager = FirestoreManager()
  private var cancellable = Set<AnyCancellable>()
  
  @Published private(set) var users: [ChatUser] = []
  
  init() {
    getAllUsers()
  }
  
  deinit {
    print("NewMessageViewModel deinit")
  }
  
  private func getAllUsers() {
    firestoreManager.getCollection(ChatUser.self, collection: .users)
      .sink {
        self.onReceiveCompletion("getAllUsers finished", $0)
      } receiveValue: { result in
        self.users = result
      }
      .store(in: &cancellable)
  }
}
