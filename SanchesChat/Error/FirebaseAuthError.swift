//
//  FirebaseAuthError.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/01/18.
//

import Foundation

enum FirebaseAuthError: Error, LocalizedError {
  case receiveJWTFailed(description: String)
  case typeConversionFailed
  case firebaseLoginFailed(description: String)
  case dataNotfound
  case updateFullNameFailed(description: String)
  
  var errorDescription: String {
    switch self {
    case .receiveJWTFailed(description: let description):
      return "에러: \(description)"
    case .typeConversionFailed:
      return "타입 변환에 실패했습니다."
    case .firebaseLoginFailed(description: let description):
      return "파이어베이스 로그인 실패: \(description)"
    case .dataNotfound:
      return "전달 받을 데이터가 없습니다."
    case .updateFullNameFailed(description: let description):
      return "FullName 업데이트에 실패: \(description)"
    }
  }
}
