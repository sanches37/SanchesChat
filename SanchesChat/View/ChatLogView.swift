//
//  ChatLogView.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/19.
//

import SwiftUI

struct ChatLogView: View {
  let chatUser: ChatUser?
  @State var text = ""
    var body: some View {
      VStack(spacing: 0) {
        ScrollView {
          ForEach(0..<10) { num in
            HStack {
              Spacer()
              Text("frke message for now")
                .fontSize(16)
                .foregroundColor(.white)
                .padding()
                .background(
                  RoundedRectangle(cornerRadius: 8)
                    .fill(.blue)
                )
            }
            .padding(.horizontal)
            .padding(.top, 8)
          }
          .padding(.vertical, 20)
        }
        Divider()
        HStack(spacing: 12) {
          Button {
          } label: {
            Image(systemName: "plus.circle")
              .fontSize(30)
              .foregroundColor(.black)
          }
          TextEditorView(text: $text)
          Button {
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
      .navigationTitle(chatUser?.name ?? "")
      .navigationBarTitleDisplayMode(.inline)
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
  }
}
