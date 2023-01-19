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
  @Published var nonce = ""
  
  func kakaoLogin() {
    kakaoAuthManager.getKakaoToken { result in
      switch result {
      case .success(let data):
        self.firebaseAuthManager.signInToFirebaseWithCustomToken(accessToken: data.accessToken)
      case .failure(let error):
        debugPrint(error.errorDescription)
      }
    }
  }
  
  func appleLogin(user: ASAuthorization) {
    do {
      firebaseAuthManager.signInToFirebaseWithAppleToken(
        token: try appleAuthManager.getAppleToken(user: user),
        nonce: self.nonce)
    } catch {
      debugPrint(error.localizedDescription)
    }
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
