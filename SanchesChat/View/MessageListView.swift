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
          isActive: Binding<Bool>(
            get: { selectedChatUser != nil },
            set: { _ in selectedChatUser = nil }
          )) {
            ChatLogView(
              currentChatUser: viewModel.chatUser,
              chatUser: selectedChatUser)
          }
      }
      .overlay(
        newMessageButton, alignment: .bottom
      )
    }
    .navigationBarHidden(true)
    .navigationViewStyle(.stack)
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
        Text("??????")
      }
      Button {
        viewModel.updateEditProfile()
      } label: {
        Text("??????")
      }
    }
    .fontSize(20, .bold)
  }
  
  private var chatList: some View {
    ScrollView {
      ForEach(viewModel.resentMessage) { message in
        NavigationLink {
          ChatLogView(
            currentChatUser: viewModel.chatUser,
            chatUser: message.toChatUser
          )
        } label: {
          HStack(spacing: 16) {
            URLImageView(url: message.toChatUser.profileImageUrl ?? "")
              .withClippedImage(
                width: 55,
                height: 55,
                clippedType: .circle)
              .overlay (
                Circle()
                  .stroke(.black, lineWidth: 1)
              )
            VStack(alignment: .leading, spacing: 5) {
              HStack {
                Text(message.toChatUser.name)
                  .fontSize(20, .bold)
                  .foregroundColor(.black)
                Spacer()
                Text(message.createdAt.toRelativeString())
                  .fontSize(14, .semibold)
                  .foregroundColor(.black)
              }
              HStack {
                Text(message.text)
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .fontSize(16)
                  .foregroundColor(.lightGray)
                  .lineLimit(1)
                
                if message.badge != 0 {
                  badgeCount(count: message.badge ?? 0)
                }
              }
            }
          }
          .padding(.bottom)
        }
      }
      .padding([.top, .horizontal])
      .padding(.bottom, 40)
    }
  }
  
  private func badgeCount(count: Int) -> some View {
    Text("\(count)")
      .fontSize(14)
      .foregroundColor(.white)
      .padding(.horizontal, 6)
      .background(
        Group {
          String(count).count == 1 ? AnyView(Circle().fill(Color.red)) :
          AnyView(Capsule().fill(Color.red))
        }
          .frame(height:22)
          .frame(minWidth: 22)
      )
  }
  
  private var newMessageButton: some View {
    Button {
      shouldShowNewMassageView.toggle()
    } label: {
      HStack {
        Spacer()
        Text("??? ????????? ?????????")
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
      }
    }
  }
  
  private var alert: Alert {
    Alert(
      title: Text("???????????? ???????????????????"),
      primaryButton: .default(Text("??????")) {
        viewModel.logOut() },
      secondaryButton: .cancel(Text("??????"))
    )
  }
}

struct MainList_Previews: PreviewProvider {
  static var previews: some View {
    MessageListView(userId: "1234")
  }
}
