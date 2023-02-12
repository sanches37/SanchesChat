//
//  FirestoreManager.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/12.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

struct FirestoreManager {
  func documentCreate<T: Encodable>(type: T, document: DocumentReference) -> AnyPublisher<Void, Error> {
    return Future<Void, FirestoreError> { promise in
      do {
        try document.setData(from: type) { error in
          if let error = error {
            promise(.failure(.unknown(description: error.localizedDescription)))
          }
          promise(.success(()))
        }
      } catch {
        promise(.failure(.unknown(description: error.localizedDescription)))
      }
    }
    .mapError { $0 as Error}
    .eraseToAnyPublisher()
  }
  
  func observeData<T: Decodable>(type: T, query: Query) -> AnyPublisher<[T], Error> {
    Publishers.QuerySnapshotPublisher<T>(query: query)
      .mapError{ $0 as Error }
      .eraseToAnyPublisher()
  }
}
