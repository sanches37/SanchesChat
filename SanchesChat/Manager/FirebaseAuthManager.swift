//
//  FirebaseAuthManager.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/01/18.
//

import Combine
import FirebaseFunctions
import FirebaseAuth

class FirebaseAuthManager {
  private lazy var functions = Functions.functions(region: "asia-northeast3")
  private let kakaoCustomTokenPath = "kakaoToken"
  
  func signInToFirebaseWithAppleToken(
    token: String,
    fullName: String?,
    nonce: String
  ) -> AnyPublisher<Void, Error> {
    return Future<Void, FirebaseAuthError> { promise in
      let firebaseCredential = OAuthProvider.credential(
        withProviderID: "apple.com",
        idToken: token,
        rawNonce: nonce
      )
      Auth.auth().signIn(with: firebaseCredential) { result, error in
        let checkResult = self.checkFirebaseLogin(result: result, error: error)
        switch checkResult {
        case .success :
          self.updateFullName(fullName: fullName) { promise($0) }
        case .failure(let error):
          promise(.failure(error))
        }
      }
    }
    .mapError { $0 as Error }
    .eraseToAnyPublisher()
  }
  
  private func updateFullName(
    fullName: String?,
    completion: @escaping (Result<Void, FirebaseAuthError>) -> Void) {
      guard let fullName = fullName,
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() else {
        completion(.success(()))
        return
      }
      changeRequest.displayName = fullName
      changeRequest.commitChanges { error in
        if let error = error {
          completion(.failure(.updateFullNameFailed(description: error.localizedDescription)))
        }
        completion(.success(()))
      }
    }
  
  func signInToFirebaseWithCustomToken(
    accessToken: String
  ) -> AnyPublisher<Void, Error> {
    return Future<Void, FirebaseAuthError> { promise in
      self.getCustomToken(
        accessToken: accessToken,
        path: self.kakaoCustomTokenPath
      ) { result in
        switch result {
        case .success(let customToken):
          Auth.auth().signIn(withCustomToken: customToken) { result, error in
            promise(self.checkFirebaseLogin(result: result, error: error))
          }
        case .failure(let error):
          promise(.failure(error))
        }
      }
    }
    .mapError { $0 as Error }
    .eraseToAnyPublisher()
  }
  
  private func getCustomToken(
    accessToken: String,
    path: String,
    completion: @escaping (Result<String, FirebaseAuthError>) -> Void) {
      functions.httpsCallable(kakaoCustomTokenPath)
        .call(["accessToken": accessToken]) { result, error in
          if let error = error {
            completion(.failure(.receiveJWTFailed(description: error.localizedDescription)))
            return
          }
          guard let data = result?.data as? String else {
            completion(.failure(.typeConversionFailed))
            return
          }
          completion(.success(data))
        }
    }
  
  private func checkFirebaseLogin(
    result: AuthDataResult?,
    error: Error?) -> Result<Void, FirebaseAuthError> {
      if let error = error {
        return .failure(.firebaseLoginFailed(description: error.localizedDescription))
      }
      guard let _ = result else {
        return .failure(.dataNotfound)
      }
      return .success(())
    }
  
  func currentUser() -> AnyPublisher<User?, Never> {
    Just(Auth.auth().currentUser).eraseToAnyPublisher()
  }
}
