//
//  AppleAuthManager.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/01/19.
//

import Combine
import AuthenticationServices

struct AppleAuthManager {
  func getAppleToken(user: ASAuthorization) -> AnyPublisher<String, AppleAuthError>  {
    guard let credential = user.credential as? ASAuthorizationAppleIDCredential,
          let token = credential.identityToken,
          let tokenString = String(data: token, encoding: .utf8) else {
      return Fail(error: AppleAuthError.tokenLookupFailed).eraseToAnyPublisher()
    }
    return Future<String, AppleAuthError> { $0(.success(tokenString))}.eraseToAnyPublisher()
  }
}
