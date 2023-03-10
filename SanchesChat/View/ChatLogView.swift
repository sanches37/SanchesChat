//
//  ChatLogView.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/19.
//

import SwiftUI

struct ChatLogView: View {
  @StateObject var viewModel: ChatLogViewModel
  
  init(currentChatUser: ChatUser?, chatUser: ChatUser?) {
    self._viewModel =
    StateObject(wrappedValue: .init(currentChatUser: currentChatUser, chatUser: chatUser))
  }
  
  var body: some View {
    VStack(spacing: 0) {
      messageLogList
      Divider()
      messageInput
    }
    .navigationTitle(viewModel.chatUser?.name ?? "")
    .navigationBarTitleDisplayMode(.inline)
  }
  
  private var messageLogList: some View {
    ScrollView {
      ScrollViewReader { proxy in
        ForEach(viewModel.chatMessages) { message in
          VStack {
            if viewModel.checkShouldShowingDate(message: message) {
              messageDateDivider(message: message)
            }
            messageLogItem(message: message)
          }
          .padding(.horizontal)
          .id(message.id)
        }
        .onChange(of: viewModel.chatMessages) { _ in
          scrollToLatest(proxy)
        }
        .onReceive(keyboardPublisher) { result in
          if result {
            scrollToLatest(proxy)
          }
        }
        .padding(.vertical)
      }
    }
  }
  
  private func scrollToLatest(_ proxy: ScrollViewProxy) {
    guard let last = viewModel.chatMessages.last else {
      return
    }
    withAnimation(.easeOut(duration: 0.5)) {
      proxy.scrollTo(last.id, anchor: .bottom)
    }
  }
  
  private func messageDateDivider(message: ChatMessage) -> some View {
    Text(message.createdAt.toDateTimeString(format: "yyyy년 MM월 dd일 E요일"))
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
          .fill(viewModel.chatText.isEmpty ? Color.lightGray : .blue)
      )
      .disabled(viewModel.chatText.isEmpty ? true : false)
    }
    .padding(.vertical, 12)
    .padding(.horizontal, 14)
  }
}
