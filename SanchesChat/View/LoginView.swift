//
//  ContentView.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/01/18.
//

import SwiftUI
import AuthenticationServices

struct LogInView: View {
  @StateObject var viewModel = LogInViewModel()
    var body: some View {
      VStack {
        Button {
          viewModel.kakaoLogIn()
        } label: {
          HStack {
            Image("kakaoSymbol")
              .resizable()
              .scaledToFit()
              .frame(width: 17)
            Text("LogIn with Kakao")
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
          viewModel.getNonce()
          request.requestedScopes = [.email, .fullName]
          request.nonce = viewModel.getSha256()
        } onCompletion: { result in
          switch result {
          case .success(let user):
            viewModel.appleLogIn(user: user)
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

struct LogInView_Previews: PreviewProvider {
  static var previews: some View {
    LogInView()
  }
}
