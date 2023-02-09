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
          debugPrint("finished")
        case .failure(let error):
          debugPrint(error.localizedDescription)
        }
      } receiveValue: { _ in }
      .store(in: &cancellable)
  }
  
  func appleLogin(user: ASAuthorization) {
    appleAuthManager.getAppleToken(user: user)
      .flatMap {
        self .firebaseAuthManager.signInToFirebaseWithAppleToken(
          token: $0,
          nonce: self.nonce
        )
      }
      .sink { completion in
        switch completion {
        case .finished:
          debugPrint("finished")
        case .failure(let error):
          debugPrint(error.localizedDescription)
        }
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
