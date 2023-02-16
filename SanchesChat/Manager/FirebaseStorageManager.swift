//
//  FirebaseStorageManager.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/16.
//

import Foundation
import Combine
import FirebaseStorage

class FirebaseStorageManager: ObservableObject {
  func updateImageToStorage(imageData: Data?, path: String) -> AnyPublisher<String?, Error> {
    return Future<String?, FirebaseStorageError> { promise in
      guard let imageData = imageData else {
        promise(.success(nil))
        return
      }
      
      let ref = Storage.storage().reference(withPath: path)
      ref.putData(imageData) { _, error in
        if let error = error {
          promise(.failure(.imageUpdateFailed(description: error.localizedDescription)))
        }
        ref.downloadURL { url, error in
          if let error = error {
            promise(.failure(.urlDownloadFailed(description: error.localizedDescription)))
          }
          guard let urlString = url?.absoluteString else {
            promise(.failure(.dataNotfound))
            return
          }
          promise(.success(urlString))
        }
      }
    }
    .mapError { $0 as Error }
    .eraseToAnyPublisher()
  }
}
