//
//  ContentView.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/01/18.
//

import SwiftUI

struct LoginView: View {
  @StateObject var contentViewModel = LoginViewModel()
    var body: some View {
      Button {
        contentViewModel.kakaoLogin()
      } label: {
        Text("카카오 로그인")
      }
    }
}
