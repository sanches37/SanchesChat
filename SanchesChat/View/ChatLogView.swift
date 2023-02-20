//
//  ChatLogView.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/19.
//

import SwiftUI

struct ChatLogView: View {
  @ObservedObject var viewModel: ChatLogViewModel
  @EnvironmentObject var appState: AppState
  
  init(chatUser: ChatUser?) {
    self.viewModel = ChatLogViewModel(chatUser: chatUser)
  }
  
  var body: some View {
    VStack(spacing: 0) {
      messageLogList
      Divider()
      messageInput
    }
    .navigationTitle(viewModel.chatUser?.name ?? "")
    .navigationBarTitleDisplayMode(.inline)
    .onAppear {
      viewModel.currentUserId = appState.userId
    }
  }
  
  private var messageLogList: some View {
    ScrollView {
      ForEach(viewModel.chatMessages) { message in
        VStack {
          if viewModel.checkShouldShowingDate(message: message) {
            messageDateDivider(message: message)
          }
          messageLogItem(message: message)
        }
        .padding(.horizontal)
      }
      .padding(.vertical)
    }
  }
  
  private func messageDateDivider(message: ChatMessage) -> some View {
    Text(message.createdAt.toDateTimeString())
      .foregroundColor(.black)
      .fontSize(12)
      .padding(8)
      .background(
        Capsule()
          .fill(Color.lightGray)
      )
  }
  
  private func messageLogItem(message: ChatMessage) -> some View {
    HStack {
      Spacer()
      Text(message.createdAt.toDateTimeString(format: "a hh:mm"))
        .foregroundColor(.black)
        .fontSize(12)
        .frame(maxHeight: .infinity, alignment: .bottom)
      Text(message.text)
        .fontSize(16)
        .foregroundColor(message.messageSource == .from ? .white : .black)
        .padding(10)
        .background(
          RoundedRectangle(cornerRadius: 8)
            .fill(message.messageSource == .from ? .blue : .lightGray)
        )
    }
    .environment(
      \.layoutDirection,
       message.messageSource == .from ? .leftToRight : .rightToLeft)
  }
  
  private var messageInput: some View {
    HStack(spacing: 12) {
      Button {
      } label: {
        Image(systemName: "plus.circle")
          .fontSize(30)
          .foregroundColor(.black)
      }
      TextEditorView(text: $viewModel.chatText)
      Button {
        viewModel.updateSendMessage()
      } label: {
        Text("보내기")
          .fontSize(16)
          .foregroundColor(.white)
      }
      .padding(8)
      .background(
        RoundedRectangle(cornerRadius: 8)
          .fill(.blue)
      )
    }
    .padding(.vertical, 12)
    .padding(.horizontal, 14)
  }
}

struct ChatLogView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ChatLogView(
        chatUser: ChatUser(
          name: "박태훈",
          email: "@naver.com",
          uid: "I9IvOqJxRAedyVC7Y3ZyQeKgfA42",
          profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/sancheschat-3af9d.appspot.com/o/I9IvOqJxRAedyVC7Y3ZyQeKgfA42?alt=media&token=d612cb12-670b-441c-95a8-419526d442bc")
      )
    }
    .environmentObject(AppState())
  }
}
