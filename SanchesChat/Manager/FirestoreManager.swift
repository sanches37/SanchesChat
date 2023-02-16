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
  func checkDocument(document: FirestoreDocument) -> AnyPublisher<Bool, Error> {
    return Future<Bool, FirestoreError> { promise in
      document.path.getDocument { document, error in
        if let error = error {
          promise(.failure(.unknown(description: error.localizedDescription)))
        }
        guard let isDocument = document?.exists else {
          promise(.failure(.dataNotfound))
          return
        }
        promise(.success(isDocument))
      }
    }
    .mapError { $0 as Error }
    .eraseToAnyPublisher()
  }
  
  func createDocument<T: Encodable>(data: T, document: FirestoreDocument) -> AnyPublisher<Void, Error> {
    return Future<Void, FirestoreError> { promise in
      do {
        try document.path.setData(from: data, merge: true) { error in
          if let error = error {
            promise(.failure(.unknown(description: error.localizedDescription)))
          }
          promise(.success(()))
        }
      } catch {
        promise(.failure(.unknown(description: error.localizedDescription)))
      }
    }
    .mapError { $0 as Error }
    .eraseToAnyPublisher()
  }
  
  func getDocument<T: Decodable>(_ type: T.Type, document: FirestoreDocument) -> AnyPublisher<T, Error> {
    return Future<T, FirestoreError> { promise in
      document.path.getDocument { snapShot, error in
        if let error = error {
          promise(.failure(.unknown(description: error.localizedDescription)))
        }
        do {
          guard let data = try snapShot?.data(as: type) else {
            promise(.failure(.dataNotfound))
            return
          }
          promise(.success(data))
        } catch {
          promise(.failure(.decodingFailed))
        }
      }
    }
    .mapError { $0 as Error }
    .eraseToAnyPublisher()
  }
  
  func observeData<T: Decodable>(type: T, query: Query) -> AnyPublisher<[T], Error> {
    Publishers.QuerySnapshotPublisher<T>(query: query)
      .mapError{ $0 as Error }
      .eraseToAnyPublisher()
  }
}

enum FirestoreDocument {
  case users(userId: String)
  
  static let db = Firestore.firestore()
  
  var path: DocumentReference {
    switch self {
    case let .users(userId: userId):
      return Self.db.collection("users").document(userId)
    }
  }
}
