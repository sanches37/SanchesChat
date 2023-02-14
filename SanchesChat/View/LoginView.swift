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
          HStack {
            Image("kakaoSymbol")
              .resizable()
              .scaledToFit()
              .frame(width: 17)
            Text("Login with Kakao")
              .bold()
              .fontSize(20)
              .foregroundColor(._000000)
          }
          .frame(height: 55)
          .frame(maxWidth: .infinity)
          .background(
            RoundedRectangle(cornerRadius: 5)
              .foregroundColor(._FEE500)
          )
          .padding(.horizontal, 30)
          
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

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    LoginView()
  }
}
