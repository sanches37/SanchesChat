//
//  KakaoAuthManager.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/01/18.
//

import Combine
import KakaoSDKUser
import KakaoSDKAuth

struct KakaoAuthManager {
  func getKakaoToken() -> AnyPublisher<OAuthToken, Error> {
    return Future<OAuthToken, KakaoAuthError> { promise in
      if AuthApi.hasToken() {
        UserApi.shared.logout { error in
          if let error = error {
            promise(.failure(.unknown(description: error.localizedDescription)))
          }
          checkedKakaoInstallState { promise($0) }
        }
      } else {
        checkedKakaoInstallState { promise($0) }
      }
    }
    .mapError { $0 as Error }
    .eraseToAnyPublisher()
  }
  
  private func checkedKakaoInstallState(
    completion: @escaping (Result<OAuthToken, KakaoAuthError>) -> Void) {
      if UserApi.isKakaoTalkLoginAvailable() {
        UserApi.shared.loginWithKakaoTalk { oAuthToken, error in
          completion(onReceiveKakaoToken(oAuthToken: oAuthToken, error: error))
        }
      } else {
        UserApi.shared.loginWithKakaoAccount { oAuthToken, error in
          completion(onReceiveKakaoToken(oAuthToken: oAuthToken, error: error))
        }
      }
    }
  
  private func onReceiveKakaoToken(
    oAuthToken: OAuthToken?,
    error: Error?) -> Result<OAuthToken, KakaoAuthError> {
      if let error = error {
        return .failure(.unknown(description: error.localizedDescription))
      }
      guard let kakaoToken = oAuthToken else {
        return .failure(.tokenLookupFailed)
      }
      print("카카오톡 로그인 성공: \(kakaoToken)")
      return .success(kakaoToken)
    }
}
