//
//  ChatUser.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/13.
//

import Foundation

struct ChatUser: Codable, Hashable {
  let name: String
  let email: String
  let uid: String
  let profileImageUrl: String?
}
