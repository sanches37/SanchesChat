//
//  MainListViewModel.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/14.
//

import Combine
import SwiftUI

class MessageListViewModel: ObservableObject {
  private let firebaseAuthManager = FirebaseAuthManager()
  private let firestoreManager = FirestoreManager()
  private let firebaseStorageManager = FirebaseStorageManager()
  private var cancellable = Set<AnyCancellable>()
  private let userId: String
  
  @Published private(set) var chatUser: ChatUser?
  @Published private(set) var resentMessage: [RecentMessage] = []
  @Published var editName = ""
  @Published var editImage: UIImage?
  @Published var isEditProfile = false
  
  init(userId: String) {
    self.userId = userId
    checkFirstUser()
    observeRecentMessages()
    resetBackgroundBadgeCount()
  }
  
  deinit {
    print("MessageListViewModel deinit")
  }
  
  private func checkFirstUser() {
    firebaseAuthManager.currentUser()
      .compactMap { $0 }
      .flatMap { user in
        self.firestoreManager.checkDocument(document: .users(userId: user.uid))
          .flatMap {
            if $0 == false {
              let chatUser = ChatUser(
                name: user.displayName ?? "",
                email: user.email ?? "",
                uid: user.uid,
                profileImageUrl: user.photoURL?.description)
              
              return self.firestoreManager.createDocument(
                data: chatUser,
                document: .users(userId: user.uid)
              )
            }
            return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
          }
      }
      .sink {
        self.onReceiveCompletion("createChatUser finished", $0)
      } receiveValue: { _ in
        self.getChatUser()
      }
      .store(in: &cancellable)
  }
  
  private func getChatUser() {
    firestoreManager.getDocument(
      ChatUser.self,
      document: .users(userId: userId)
    )
    .sink {
      self.onReceiveCompletion("getChatUser finished", $0)
    } receiveValue: { result in
      self.chatUser = result
      self.editName = result.name
    }
    .store(in: &cancellable)
  }
  
  private func observeRecentMessages() {
    firestoreManager.observeCollection(
      RecentMessage.self, query: .fetchRecentMessage(userId: userId))
    .sink { [weak self] completion in
      self?.onReceiveCompletion("observeRecentMessages finished", completion)
    } receiveValue: { [weak self] result in
      self?.resentMessage = result
    }
    .store(in: &cancellable)
  }
  
  private func resetBackgroundBadgeCount() {
    $resentMessage
      .map { result in
        result
          .map { $0.badge }
          .reduce(0, +)
      }
      .sink {
        UIApplication.shared.applicationIconBadgeNumber = $0
      }
      .store(in: &cancellable)
  }
  
  func updateEditProfile() {
    checkEditImage()
      .flatMap { imageURL in
        let profileData = ["name": self.editName, "profileImageUrl": imageURL]
        let documentData = ["toChatUser.name": self.editName, "toChatUser.profileImageUrl": imageURL]
        return Publishers.Zip(
          self.firestoreManager.createDocument(
            data: profileData,
            document: .users(userId: self.userId)
          ),
          self.firestoreManager.getCollectionAfterUpdate(
            type: documentData as [String : Any],
            collection: .users,
            afterCollection: "recentMessages",
            afterDocument: self.userId)
        )
      }
      .sink {
        self.onReceiveCompletion("updateEditProfile finished", $0)
      } receiveValue: { _ in
        self.isEditProfile = false
        self.getChatUser()
      }
      .store(in: &cancellable)
  }
  
  private func checkEditImage() -> AnyPublisher<String?, Error> {
    if let image = editImage,
       let imageData = image.jpegData(compressionQuality: 0.5){
      return firebaseStorageManager.updateImageToStorage(imageData: imageData, path: userId)
        .map { Optional($0) }
        .eraseToAnyPublisher()
    } else {
      return Just(chatUser?.profileImageUrl).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
  }
  
  func cancelEditProfile() {
    editImage = nil
    editName = chatUser?.name ?? ""
    isEditProfile = false
  }
  
  func logOut() {
    firebaseAuthManager.firebaseLogOut()
      .sink {
        self.onReceiveCompletion("LogOut finished", $0)
      } receiveValue: { _ in }
      .store(in: &cancellable)
  }
}
