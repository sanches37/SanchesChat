//
//  AppleAuthManager.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/01/19.
//

import Foundation
import AuthenticationServices

struct AppleAuthManager {
  func getAppleToken(user: ASAuthorization) throws -> String {
    guard let credential = user.credential as? ASAuthorizationAppleIDCredential,
          let token = credential.identityToken,
          let tokenString = String(data: token, encoding: .utf8) else {
      throw AppleAuthError.tokenLookupFailed
    }
    return tokenString
  }
}
