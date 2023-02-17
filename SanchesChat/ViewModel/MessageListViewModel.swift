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
  @Published var editName = ""
  @Published var editImage: UIImage?
  @Published var isEditProfile = false
  
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
      self.editName = result.name
    }
    .store(in: &cancellable)
  }
  
  func updateEditProfile() {
    checkEditImage()
      .flatMap { imageURL -> AnyPublisher<Void, Error> in
        let data = ["name": self.editName, "profileImageUrl": imageURL]
        return self.firestoreManager.createDocument(data: data, document: .users(userId: self.userId))
      }
      .sink { completion in
        switch completion {
        case .finished:
          debugPrint("updateEditProfile finished")
        case let .failure(error):
          debugPrint(error.localizedDescription)
        }
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
