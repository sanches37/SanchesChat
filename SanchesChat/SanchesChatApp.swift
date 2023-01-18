//
//  SanchesChatApp.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/01/18.
//

import SwiftUI
import Firebase
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct SanchesChatApp: App {
  var body: some Scene {
    WindowGroup {
      LoginView()
        .onOpenURL { url in
          if AuthApi.isKakaoTalkLoginUrl(url) {
            _ = AuthController.handleOpenUrl(url: url)
          }
        }
    }
  }
  
  init() {
    initFirebaseSDK()
    initKakaoSDK()
  }
  
  private func initFirebaseSDK() {
    FirebaseApp.configure()
  }
  
  private func initKakaoSDK() {
    guard let appKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_KEY") as? String else { return }
    KakaoSDK.initSDK(appKey: appKey)
  }
}
