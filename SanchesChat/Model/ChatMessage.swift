//
//  ChatMessage.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/19.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct ChatMessage: Codable, Identifiable {
  @DocumentID var id: String?
  let messageSource: MessageSourceType
  let text: String
  let createdAt: Date
}

enum MessageSourceType: String, Codable {
  case from
  case to
}
