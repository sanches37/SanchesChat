//
//  RecentMessage.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/20.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct RecentMessage: Codable, Identifiable {
  @DocumentID var id: String?
  let toChatUser: ChatUser
  let text: String
  let createdAt: Date
}
