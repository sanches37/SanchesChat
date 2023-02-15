//
//  URLImage.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/15.
//

import SwiftUI
import Kingfisher

struct URLImageView: View {
  let url: String
  var body: some View {
    KFImage(URL(string: url))
      .placeholder {
        GeometryReader { geometry  in
          Rectangle().fill(Color._AFEEEE)
            .overlay(
              Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, geometry.size.width * 0.2)
                .padding(.vertical, geometry.size.height * 0.2)
            )
        }
      }
      .resizable()
  }
}

