//
//  FirestoreMessagingError.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/24.
//

import Foundation

enum FirestoreMessagingError: Error, LocalizedError {
  case subscribeFailed
  case unSubscribeFailed
  
  var errorDescription: String {
    switch self {
    case .subscribeFailed:
      return "topic 등록 실패."
    case .unSubscribeFailed:
      return "topic 해제 실패."
    }
  }
}
