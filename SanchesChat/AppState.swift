//
//  AppState.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/14.
//

import Foundation
import Combine

class AppState: ObservableObject {
  private let firebaseAuthManager = FirebaseAuthManager()
  private let firebaseMessagingManager = FirebaseMessagingManager()
  private var cancellable = Set<AnyCancellable>()
  
  @Published private(set) var userId: String? {
    didSet {
      if let oldValue = oldValue {
        cancelPushTopic(toTopic: oldValue)
      }
    }
  }
  
  init() {
    observeCurrentUserId()
    registerPushTopic()
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
  
  private func registerPushTopic() {
    $userId
      .compactMap { $0 }
      .combineLatest(NotificationCenter.default.publisher(for: .fcmToken))
      .sink { [weak self] userId, _ in
        self?.firebaseMessagingManager.subscribeToTopic(toTopic: userId)
      }
      .store(in: &cancellable)
  }
  
  private func cancelPushTopic(toTopic: String) {
    firebaseMessagingManager.unSubscribeToTopic(toTopic: toTopic)
  }
}
