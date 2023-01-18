//
//  FirebaseAuthManager.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/01/18.
//

import FirebaseFunctions
import FirebaseAuth

class FirebaseAuthManager {
  private lazy var functions = Functions.functions(region: "asia-northeast3")
  private let path = "kakaoToken"
  
  func signInToFirebaseWithToken(accessToken: String) {
    getKakaoCustomToken(accessToken: accessToken) { result in
      switch result {
      case .success(let customToken):
        Auth.auth().signIn(withCustomToken: customToken) { result, error in
          do {
            try self.checkFirebaseLogin(result: result, error: error)
          } catch {
            debugPrint(error.localizedDescription)
          }
        }
      case .failure(let error):
        debugPrint(error.errorDescription)
      }
    }
  }
  
  private func getKakaoCustomToken(
    accessToken: String,
    completion: @escaping (Result<String, FirebaseAuthError>) -> Void) {
      functions.httpsCallable(path)
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
    error: Error?) throws {
    if let error = error {
      throw FirebaseAuthError.firebaseLoginFailed(description: error.localizedDescription)
    }
    guard let result = result else {
      throw FirebaseAuthError.dataNotfound
    }
      print("파이어베이스 로그인 성공: \(result.user.email ?? "")")
  }
}
