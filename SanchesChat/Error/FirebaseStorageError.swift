//
//  FirebaseStorageError.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/16.
//

import Foundation

enum FirebaseStorageError: Error, LocalizedError {
  case imageUpdateFailed(description: String)
  case urlDownloadFailed(description: String)
  case dataNotfound
  
  var errorDescription: String {
    switch self {
    case .imageUpdateFailed(description: let description):
      return "업데이트 에러: \(description)"
    case .urlDownloadFailed(description: let description):
      return "다운로드 에러: \(description)"
    case .dataNotfound:
      return "전달 받을 데이터가 없습니다."
    }
  }
}
