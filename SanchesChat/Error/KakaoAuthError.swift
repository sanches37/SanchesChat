//
//  KakaoAuthError.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/01/18.
//

import Foundation

enum KakaoAuthError: Error, LocalizedError {
  case unknown(description: String)
  case tokenLookupFailed
  
  var errorDescription: String {
    switch self {
    case .unknown(description: let description):
      return "에러: \(description)"
    case .tokenLookupFailed:
      return "토큰을 변환하지 못했습니다."
    }
  }
}
