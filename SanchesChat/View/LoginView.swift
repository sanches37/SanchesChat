//
//  ContentView.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/01/18.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
  @StateObject var loginViewModel = LoginViewModel()
    var body: some View {
      VStack {
        Button {
          loginViewModel.kakaoLogin()
        } label: {
          Text("카카오 로그인")
        }
        SignInWithAppleButton { request in
          loginViewModel.getNonce()
          request.requestedScopes = [.email, .fullName]
          request.nonce = loginViewModel.getSha256()
        } onCompletion: { result in
          switch result {
          case .success(let user):
            loginViewModel.appleLogin(user: user)
          case .failure(let error):
            debugPrint(error.localizedDescription)
          }
        }
        .signInWithAppleButtonStyle(.black)
        .frame(height: 55)
        .padding(.horizontal, 30)
      }
    }
}
