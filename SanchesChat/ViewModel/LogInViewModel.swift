//
//  ContentViewModel.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/01/18.
//

import Foundation
import Combine
import AuthenticationServices

class LogInViewModel: ObservableObject {
  private let kakaoAuthManager = KakaoAuthManager()
  private let appleAuthManager = AppleAuthManager()
  private let firebaseAuthManager = FirebaseAuthManager()
  private let nonceManager = NonceManager()
  private var cancellable = Set<AnyCancellable>()
  @Published var nonce = ""
  
  deinit {
    print("LogInViewModel deinit")
  }
  
  func kakaoLogIn() {
    kakaoAuthManager.getKakaoToken()
      .flatMap {
        self.firebaseAuthManager.signInToFirebaseWithCustomToken(
          accessToken: $0.accessToken
        )
      }
      .sink {
        self.onReceiveCompletion("logIn finished", $0)
      } receiveValue: { _ in }
      .store(in: &cancellable)
  }
  
  func appleLogIn(user: ASAuthorization) {
    appleAuthManager.getAppleToken(user: user)
      .flatMap {
        self.firebaseAuthManager.signInToFirebaseWithAppleToken(
          token: $0,
          fullName: self.appleAuthManager.getApplFullName(user: user),
          nonce: self.nonce
        )
      }
      .sink {
        self.onReceiveCompletion("logIn finished", $0)
      } receiveValue: { _ in }
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
}
