//
//  ChatLogViewModel.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/19.
//

import Foundation
import Combine

class ChatLogViewModel: ObservableObject {
  private let firestoreManager = FirestoreManager()
  private let firebaseAuthManager = FirebaseAuthManager()
  private var cancellable = Set<AnyCancellable>()
  
  @Published var chatMessages: [ChatMessage] = []
  @Published var chatUser: ChatUser?
  @Published var currentUserId: String?
  @Published var chatText = ""
  
  init(chatUser: ChatUser?) {
    self.chatUser = chatUser
    observeMessage()
  }
  
  private func observeMessage() {
    guard let toId = chatUser?.uid else { return }
    
    $currentUserId
      .compactMap { $0 }
      .flatMap { [weak self] fromId -> AnyPublisher<[ChatMessage], Error> in
        guard let self = self else {
          return Fail(error: CommonError.weakSelfNotfound).eraseToAnyPublisher()
        }
        return self.firestoreManager.observeCollection(
          ChatMessage.self,
          query: .fetchMessage(fromId: fromId, toId: toId)
        )
      }
      .sink { completion in
        switch completion {
        case .finished:
          debugPrint("observeMessage finished")
        case let .failure(error):
          debugPrint(error.localizedDescription)
        }
      } receiveValue: { [weak self] result in
        self?.chatMessages = result
      }
      .store(in: &cancellable)
  }
  
  func updateSendMessage() {
    guard let fromId = currentUserId,
          let toId = chatUser?.uid else { return }
    let fromData = ChatMessage(messageSource: .from, text: self.chatText, createdAt: Date())
    let toData = ChatMessage(messageSource: .to, text: self.chatText, createdAt: Date())
    
    Publishers.Zip(
      firestoreManager.createDocument(
        data: fromData,
        document: .sendMessage(fromId: fromId, toId: toId)),
      firestoreManager.createDocument(
        data: toData,
        document: .sendMessage(fromId: toId, toId: fromId))
    )
    .sink { completion in
      switch completion {
      case .finished:
        debugPrint("sendMessage finished")
      case let .failure(error):
        debugPrint(error.localizedDescription)
      }
    } receiveValue: { _ in
      self.chatText = ""
    }
    .store(in: &cancellable)
  }
  
  func checkShouldShowingDate(message: ChatMessage) -> Bool {
    let lhs = message
    guard let lhsIndex = chatMessages.firstIndex(of: lhs),
          lhsIndex != 0 else {
      return true
    }
    let rhsIndex = lhsIndex - 1
    let rhs = chatMessages[rhsIndex]
    return !lhs.createdAt.checkIsSameDay(compareTo: rhs.createdAt)
  }
}
