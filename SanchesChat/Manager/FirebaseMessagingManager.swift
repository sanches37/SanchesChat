//
//  FirebaseMessagingManager.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/24.
//

import Foundation
import FirebaseMessaging

struct FirebaseMessagingManager {
  func subscribeToTopic(toTopic: String) {
    Messaging.messaging().subscribe(toTopic: toTopic) { error in
      if let error = error {
        debugPrint("topic 구독 실패: \(error.localizedDescription)")
      }
    }
  }
  
  func unSubscribeToTopic(toTopic: String) {
    Messaging.messaging().unsubscribe(fromTopic: toTopic) { error in
      if let error = error {
        debugPrint("topic 해제 실패: \(error.localizedDescription)")
      }
    }
  }
}
