//
//  AppleAuthManager.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/01/19.
//

import Combine
import AuthenticationServices

struct AppleAuthManager {
  func getAppleToken(user: ASAuthorization) -> AnyPublisher<String, Error>  {
    guard let credential = user.credential as? ASAuthorizationAppleIDCredential,
          let token = credential.identityToken,
          let tokenString = String(data: token, encoding: .utf8) else {
      return Fail(error: AppleAuthError.tokenLookupFailed).eraseToAnyPublisher()
    }
    return Just(tokenString).setFailureType(to: Error.self).eraseToAnyPublisher()
  }
  
  func getApplFullName(user: ASAuthorization) -> String? {
    guard let credential = user.credential as? ASAuthorizationAppleIDCredential,
          let familyName = credential.fullName?.familyName,
          let givenName = credential.fullName?.givenName else { return nil }
    return "\(familyName) \(givenName)"
  }
}
