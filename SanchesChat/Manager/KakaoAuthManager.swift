//
//  KakaoAuthManager.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/01/18.
//

import Foundation
import KakaoSDKUser
import KakaoSDKAuth

struct KakaoAuthManager {
  func getKakaoToken(completion: @escaping (Result<OAuthToken, KakaoAuthError>) -> Void) {
    if AuthApi.hasToken() {
      UserApi.shared.logout { error in
        if let error = error {
          completion(.failure(.unknown(description: error.localizedDescription)))
        }
        checkedKakaoInstallState { result in
          completion(.success(result))
        }
      }
    } else {
      checkedKakaoInstallState { result in
        completion(.success(result))
      }
    }
  }
  
  private func checkedKakaoInstallState(completion: @escaping ((OAuthToken) -> Void)) {
    if UserApi.isKakaoTalkLoginAvailable() {
      UserApi.shared.loginWithKakaoTalk { oAuthToken, error in
        do {
          completion(try self.onReceiveKakaoToken(oAuthToken: oAuthToken, error: error))
        } catch {
          debugPrint(error.localizedDescription)
        }
      }
    } else {
      UserApi.shared.loginWithKakaoAccount { oAuthToken, error in
        do {
          completion(try self.onReceiveKakaoToken(oAuthToken: oAuthToken, error: error))
        } catch {
          debugPrint(error.localizedDescription)
        }
      }
    }
  }
  
  private func onReceiveKakaoToken(oAuthToken: OAuthToken?, error: Error?) throws -> OAuthToken {
    if let error = error {
      throw KakaoAuthError.unknown(description: error.localizedDescription)
    } else {
      guard let kakaoToken = oAuthToken else {
        throw KakaoAuthError.tokenLookupFailed
      }
      print("카카오톡 로그인 성공: \(kakaoToken)")
      return kakaoToken
    }
  }
}
