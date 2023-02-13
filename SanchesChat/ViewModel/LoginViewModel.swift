//
//  ContentViewModel.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/01/18.
//

import Foundation
import Combine
import AuthenticationServices

class LoginViewModel: ObservableObject {
  private let kakaoAuthManager = KakaoAuthManager()
  private let appleAuthManager = AppleAuthManager()
  private let firebaseAuthManager = FirebaseAuthManager()
  private let nonceManager = NonceManager()
  private let firestoreManager = FirestoreManager()
  private var cancellable = Set<AnyCancellable>()
  @Published var nonce = ""
  
  func kakaoLogin() {
    kakaoAuthManager.getKakaoToken()
      .flatMap {
        self.firebaseAuthManager.signInToFirebaseWithCustomToken(
          accessToken: $0.accessToken
        )
      }
      .sink { completion in
        switch completion {
        case .finished:
          debugPrint("login finished")
        case .failure(let error):
          debugPrint(error.localizedDescription)
        }
      } receiveValue: { _ in
        self.createUser()
      }
      .store(in: &cancellable)
  }
  
  func appleLogin(user: ASAuthorization) {
    appleAuthManager.getAppleToken(user: user)
      .flatMap {
        self .firebaseAuthManager.signInToFirebaseWithAppleToken(
          token: $0,
          fullName: self.appleAuthManager.getApplFullName(user: user),
          nonce: self.nonce
        )
      }
      .sink { completion in
        switch completion {
        case .finished:
          debugPrint("login finished")
        case .failure(let error):
          debugPrint(error.localizedDescription)
        }
      } receiveValue: { _ in
        self.createUser()
      }
      .store(in: &cancellable)
  }
  
  func getSha256() -> String {
    self.nonceManager.sha256(
      self.nonce
    )
  }
  
  func getNonce() {
    self.nonce = nonceManager.randomNonceString()
  }
  
  private func createUser() {
    firebaseAuthManager.currentUser()
      .compactMap { $0 }
      .flatMap { user -> AnyPublisher<Void, Error> in
        self.firestoreManager.checkDocument(document: .users(uid: user.uid))
          .flatMap {
            if $0 == false {
              let chatUser = ChatUser(
                name: user.displayName ?? "",
                email: user.email ?? "",
                uid: user.uid,
                profileImageUrl: user.photoURL?.description)
              
              return self.firestoreManager.createDocument(
                data: chatUser,
                document: .users(uid: user.uid)
              )
            }
            return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
          }
          .eraseToAnyPublisher()
      }
      .sink { completion in
        switch completion {
        case .finished:
          debugPrint("createUser finished")
        case .failure(let error):
          debugPrint(error.localizedDescription)
        }
      } receiveValue: { _ in }
      .store(in: &cancellable)
  }
}
