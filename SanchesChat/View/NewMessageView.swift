//
//  NewMessageView.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/17.
//

import SwiftUI

struct NewMessageView: View {
  @ObservedObject private var viewModel = NewMessageViewModel()
  @Environment(\.presentationMode) var presentationMode
    var body: some View {
      NavigationView {
        ScrollView {
          ForEach(viewModel.users, id: \.self.uid) { user in
            HStack(spacing: 16) {
              URLImageView(url: user.profileImageUrl ?? "")
                .withClippedImage(
                  width: 60,
                  height: 60,
                  clippedType: .circle)
                .overlay (
                  Circle()
                    .stroke(.black, lineWidth: 1)
                )
              Text(user.name)
                .fontSize(24, .bold)
                .lineLimit(1)
              Spacer()
            }
            .padding(.horizontal)
          }
        }
        .navigationTitle("New Message")
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            Button {
              presentationMode.wrappedValue.dismiss()
            } label: {
              Text("Cancel")
            }
          }
        }
      }
    }
}

struct NewMessageView_Previews: PreviewProvider {
    static var previews: some View {
        NewMessageView()
    }
}
