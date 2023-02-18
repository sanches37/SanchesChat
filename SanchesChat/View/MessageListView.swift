//
//  MainListView.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/14.
//

import SwiftUI

struct MessageListView: View {
  @StateObject private var viewModel: MessageListViewModel
  @State private var shouldShowLogOutAlert = false
  @State private var shouldShowImagePicker = false
  @State private var shouldShowNewMassageView = false
  @State private var shouldShowChatLogView = false
  @State private var selectedChatUser: ChatUser?
  
  init(userId: String) {
    _viewModel = StateObject(wrappedValue: .init(userId: userId))
  }
  
  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        myProfile
        chatList
        NavigationLink(
          "",
          isActive: $shouldShowChatLogView) {
            Text("chat")
          }
      }
      .overlay(
        newMessageButton, alignment: .bottom
      )
    }
    .navigationBarHidden(true)
  }
  
  private var myProfile: some View {
    HStack(spacing: 16) {
      if viewModel.isEditProfile {
        defaultImage
          .overlay(
            Image(systemName: "plus")
              .fontSize(13, .bold)
              .foregroundColor(.black)
              .padding(4)
              .background(
                Circle()
                  .fill(Color.white)
              )
            , alignment: .bottomTrailing
          )
          .onTapGesture {
            shouldShowImagePicker.toggle()
          }
      } else {
        defaultImage
      }
      
      Group {
        viewModel.isEditProfile ? AnyView(editText) : AnyView(defaultText)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .fontSize(24, .bold)
      
      viewModel.isEditProfile ? AnyView(editProfileButton) :AnyView(defaultProfileButton)
    }
    .padding()
    .foregroundColor(.black)
    .background(
      Color.royalBlue
        .edgesIgnoringSafeArea(.top)
    )
    .alert(isPresented: $shouldShowLogOutAlert) {
      alert
    }
    .fullScreenCover(isPresented: $shouldShowImagePicker) {
      ImagePicker(image: $viewModel.editImage)
    }
  }
  
  private var defaultImage: some View {
    Group {
      if let image = viewModel.editImage {
        Image(uiImage: image)
          .resizable()
      } else {
        URLImageView(url: viewModel.chatUser?.profileImageUrl ?? "")
      }
    }
    .withClippedImage(
      width: 60,
      height: 60,
      clippedType: .circle)
    .overlay (
      Circle()
        .stroke(.black, lineWidth: 1)
    )
  }
  
  private var defaultText: some View {
    Text(viewModel.chatUser?.name ?? "")
      .lineLimit(1)
      .offset(y: 0.5)
  }
  
  private var editText: some View {
    TextField("", text: $viewModel.editName)
  }
  
  private var defaultProfileButton: some View {
    HStack(spacing: 16) {
      Button {
        viewModel.isEditProfile = true
      } label: {
        Image(systemName: "gear")
      }
      Button {
        shouldShowLogOutAlert.toggle()
      } label: {
        Image(systemName: "rectangle.portrait.and.arrow.right")
      }
    }
    .fontSize(24, .bold)
  }
  
  private var editProfileButton: some View {
    HStack(spacing: 16) {
      Button {
        viewModel.cancelEditProfile()
      } label: {
        Text("취소")
      }
      Button {
        viewModel.updateEditProfile()
      } label: {
        Text("저장")
      }
    }
    .fontSize(20, .bold)
  }
  
  private var chatList: some View {
    ScrollView {
      ForEach(0..<10, id: \.self) { num in
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
      .padding(.bottom, 50)
    }
  }
  
  private var newMessageButton: some View {
    Button {
      shouldShowNewMassageView.toggle()
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
    .fullScreenCover(isPresented: $shouldShowNewMassageView) {
      NewMessageView { user in
        self.selectedChatUser = user
        self.shouldShowChatLogView.toggle()
      }
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
