//
//  MainListView.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/14.
//

import SwiftUI

struct MessageListView: View {
  @ObservedObject private var viewModel: MessageListViewModel
  @State private var isLogOut = false
  
  init(userId: String) {
    _viewModel = ObservedObject(wrappedValue: .init(userId: userId))
  }
  
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
    .alert(isPresented: $isLogOut) {
      alert
    }
    .navigationBarHidden(true)
  }
  
  private var myProfile: some View {
    HStack(spacing: 16) {
      URLImageView(url: viewModel.chatUser?.profileImageUrl ?? "")
        .withClippedImage(
          width: 60,
          height: 60,
          clippedType: .circle)
        .overlay (
          Circle()
            .stroke(Color(.label), lineWidth: 1)
        )
      Text(viewModel.chatUser?.name ?? "")
        .fontSize(24, .bold)
        .foregroundColor(Color(.label))
      Spacer()
      Button {
        isLogOut.toggle()
      } label: {
        Image(systemName: "rectangle.portrait.and.arrow.right")
          .fontSize(24, .bold)
          .foregroundColor(Color(.label))
      }
    }
    .padding()
    .background(
      Color.royalBlue
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
                  .background(Circle().fill(Color.paleTurquoise))
              )
            VStack(alignment: .leading, spacing: 5) {
              Text("Username")
                .fontSize(16, .bold)
                .foregroundColor(Color(.label))
              Text("Message sent to user")
                .fontSize(14)
                .foregroundColor(.lightGray)
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
      .foregroundColor(.white)
      .padding(.vertical)
      .background(
        RoundedRectangle(cornerRadius: 32)
          .foregroundColor(.rosyBrown)
      )
      .padding(.horizontal)
    }
  }
  
  private var alert: Alert {
    Alert(
      title: Text("로그아웃 하시겠습니까?"),
      primaryButton: .default(Text("확인")) {
        viewModel.logOut() },
      secondaryButton: .cancel(Text("취소"))
    )
  }
}

struct MainList_Previews: PreviewProvider {
  static var previews: some View {
    MessageListView(userId: "1234")
  }
}
