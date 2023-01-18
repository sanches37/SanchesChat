//
//  ContentViewModel.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/01/18.
//

import Foundation

class LoginViewModel: ObservableObject {
  private let kakaoAuthManager = KakaoAuthManager()
  private let fireBaseAuthManager = FirebaseAuthManager()
  
  func kakaoLogin() {
    kakaoAuthManager.getKakaoToken { result in
      switch result {
      case .success(let data):
        self.fireBaseAuthManager.signInToFirebaseWithToken(accessToken: data.accessToken)
      case .failure(let error):
        debugPrint(error.errorDescription)
      }
    }
  }
}
