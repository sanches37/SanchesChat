//
//  MainListViewModel.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/14.
//

import Combine

class MessageListViewModel: ObservableObject {
  private let firebaseAuthManager = FirebaseAuthManager()
  private var cancellabel = Set<AnyCancellable>()
  private let userId: String
  
  init(userId: String) {
    self.userId = userId
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
      .store(in: &cancellabel)
  }
}
