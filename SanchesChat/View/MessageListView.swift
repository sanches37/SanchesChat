//
//  MainListView.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/14.
//

import SwiftUI

struct MessageListView: View {
  @StateObject private var viewModel = MessageListViewModel()
  @State private var profileOption = false
  
  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        myProfile
        chatList
      }
    }
    .overlay(
      newMessageButton, alignment: .bottom
    )
    .actionSheet(isPresented: $profileOption) {
      actionSheet
    }
    .navigationBarHidden(true)
  }
  
  private var myProfile: some View {
    HStack(spacing: 16) {
      Image(systemName: "person.fill")
        .fontSize(40)
        .padding(8)
        .background (
          Circle()
            .stroke(Color(.label), lineWidth: 1)
            .background(Circle().fill(Color._AFEEEE))
         )
      Text("USERNAME")
        .fontSize(24, .bold)
        .foregroundColor(Color(.label))
      Spacer()
      Button {
        profileOption.toggle()
      } label: {
        Image(systemName: "gear")
          .fontSize(24, .bold)
          .foregroundColor(Color(.label))
      }
    }
    .padding()
    .background(
      Color._4169E1
        .edgesIgnoringSafeArea(.top)
    )
  }
  
  private var chatList: some View {
    ScrollView {
      ForEach(0..<10, id: \.self) { num in
        VStack {
          HStack(spacing: 16) {
            Image(systemName: "person.fill")
              .fontSize(32)
              .padding(8)
              .background (
                Circle()
                  .stroke(Color(.label), lineWidth: 1)
                  .background(Circle().fill(Color._AFEEEE))
               )
            VStack(alignment: .leading, spacing: 5) {
              Text("Username")
                .fontSize(16, .bold)
                .foregroundColor(Color(.label))
              Text("Message sent to user")
                .fontSize(14)
                .foregroundColor(._D3D3D3)
            }
            Spacer()
            Text("22d")
              .fontSize(14, .semibold)
          }
          .padding(.horizontal)
          .padding(.vertical, 10)
        }
      }
      .padding(.bottom, 50)
    }
  }
  
  private var newMessageButton: some View {
    Button {
    } label: {
      HStack {
        Spacer()
        Text("새 메시지 보내기")
          .fontSize(20, .bold)
        Spacer()
      }
      .foregroundColor(._FFFFFF)
      .padding(.vertical)
      .background(
        RoundedRectangle(cornerRadius: 32)
          .foregroundColor(._BC8F8F)
      )
      .padding(.horizontal)
    }
  }
  
  private var actionSheet: ActionSheet {
    ActionSheet(
      title: Text("Settings"),
      buttons: [
        .default(Text("프로필 수정")) {
          print("프로필") },
        .destructive(Text("로그아웃")) {
          viewModel.logOut() }
      ]
    )
  }
}

struct MainList_Previews: PreviewProvider {
  static var previews: some View {
    MessageListView()
  }
}
