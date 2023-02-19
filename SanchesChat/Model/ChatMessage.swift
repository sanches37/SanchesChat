//
//  ChatMessage.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/19.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct ChatMessage: Codable {
  @DocumentID var id: String?
  let fromId: String
  let toId: String
  let text: String
  var createdAt: Date = Date()
}
