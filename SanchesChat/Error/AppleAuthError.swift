//
//  AppleAuthError.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/01/19.
//

import Foundation

enum AppleAuthError: Error, LocalizedError {
  case tokenLookupFailed
  
  var errorDescription: String {
    switch self {
    case .tokenLookupFailed:
      return "토큰을 변환하지 못했습니다."
    }
  }
}
