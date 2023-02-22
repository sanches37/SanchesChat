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
  @Published var currentChatUser: ChatUser?
  @Published var chatUser: ChatUser?
  @Published var chatText = ""
  
  init(currentChatUser: ChatUser?, chatUser: ChatUser?) {
    self.chatUser = chatUser
    self.currentChatUser = currentChatUser
    observeMessage()
  }
  
  private func observeMessage() {
    guard let toId = chatUser?.uid else { return }
    
    $currentChatUser
      .compactMap { $0?.uid }
      .flatMap { [weak self] fromId -> AnyPublisher<[ChatMessage], Error> in
        return self?.firestoreManager.observeCollection(
          ChatMessage.self,
          query: .fetchMessage(fromId: fromId, toId: toId)
        ) ?? Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
      }
      .sink {
        self.onReceiveCompletion("observeMessage finished", $0)
      } receiveValue: { [weak self] result in
        self?.chatMessages = result
      }
      .store(in: &cancellable)
  }
  
  func updateSendMessage() {
    guard let fromUser = currentChatUser,
          let toUser = chatUser else { return }
    let fromData = ChatMessage(messageSource: .from, text: chatText, createdAt: Date())
    let toData = ChatMessage(messageSource: .to, text: chatText, createdAt: Date())
    let recentFromData = RecentMessage(toChatUser: toUser, text: chatText, createdAt: Date())
    let recentToData = RecentMessage(toChatUser: fromUser, text: chatText, createdAt: Date())
    
    Publishers.Zip4(
      firestoreManager.createDocument(
        data: fromData,
        document: .sendMessage(fromId: fromUser.uid, toId: toUser.uid)),
      firestoreManager.createDocument(
        data: toData,
        document: .sendMessage(fromId: toUser.uid, toId: fromUser.uid)),
      firestoreManager.createDocument(
        data: recentFromData,
        document: .recentMessage(userId: fromUser.uid, toId: toUser.uid)),
      firestoreManager.createDocument(
        data: recentToData,
        document: .recentMessage(userId: toUser.uid, toId: fromUser.uid))
    )
    .sink {
      self.onReceiveCompletion("sendMessage finished", $0)
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
