//
//  ChatLogViewModel.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/19.
//

import Combine

class ChatLogViewModel: ObservableObject {
  private let firestoreManager = FirestoreManager()
  private var cancellable = Set<AnyCancellable>()
  
  @Published var chatUser: ChatUser?
  @Published var chatText = ""
  
  init(chatUser: ChatUser?) {
    self.chatUser = chatUser
  }
  
  func updateSendMessage(fromId: String?) {
    guard let fromId = fromId,
          let toId = chatUser?.uid else { return }
    let data = ChatMessage(fromId: fromId, toId: toId, text: self.chatText)

    firestoreManager.createDocument(
      data: data,
      document: .sendMessage(fromId: fromId, toId: toId))
    .sink { completion in
      switch completion {
      case .finished:
        debugPrint("sendMessage finished")
      case let .failure(error):
        debugPrint(error.localizedDescription)
      }
    } receiveValue: { _ in }
    .store(in: &cancellable)
  }
}
