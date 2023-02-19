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
      document.path.getDocument { promise(document.getProcess($0, $1)) }
    }
    .mapError { $0 as Error }
    .eraseToAnyPublisher()
  }
  
  func getCollection<T: Decodable>(_ type: T.Type, collection: FirestoreCollecion) -> AnyPublisher<[T], Error> {
    return Future<[T], FirestoreError> { promise in
      collection.path.getDocuments { promise(collection.getProcess(type, $0, $1)) }
    }
    .mapError { $0 as Error }
    .eraseToAnyPublisher()
  }
  
  func observeData<T: Decodable>(_ type: T.Type, query: FirestoreCollecion) -> AnyPublisher<[T], Error> {
    Publishers.QuerySnapshotPublisher(query: query)
      .mapError{ $0 as Error }
      .eraseToAnyPublisher()
  }
}

enum FirestoreDocument {
  case users(userId: String)
  case sendMessage(fromId: String, toId: String)
  
  static let db = Firestore.firestore()
  
  var path: DocumentReference {
    switch self {
    case let .users(userId: userId):
      return Self.db.collection("users").document(userId)
    case let .sendMessage(fromId, toId):
      return Self.db
        .collection("messages")
        .document(fromId)
        .collection(toId)
        .document()
    }
  }
  
  func getProcess<T: Decodable>(
    _ snapshot: DocumentSnapshot?,
    _ error: Error?) -> Result<T, FirestoreError> {
      if let error = error {
        return .failure(.unknown(description: error.localizedDescription))
      }
      do {
        guard let data = try snapshot?.data(as: T.self) else {
          return .failure(.dataNotfound)
        }
        return .success(data)
      } catch {
        return .failure(.decodingFailed)
      }
    }
}

enum FirestoreCollecion {
  case users
  
  static let db = Firestore.firestore()
  
  var path: CollectionReference {
    switch self {
    case .users:
      return Self.db.collection("users")
    }
  }
  
  func getProcess<T: Decodable>(
    _ type: T.Type,
    _ snapshot: QuerySnapshot?,
    _ error: Error?) -> Result<[T], FirestoreError> {
      if let error = error {
        return .failure(.unknown(description: error.localizedDescription))
      }
      guard let snapshot = snapshot?.documents else {
        return .failure(.dataNotfound)
      }
      do {
        let dataArray = try snapshot.compactMap {
          try $0.data(as: T.self)
        }
        return .success(dataArray)
      } catch {
        return .failure(.decodingFailed)
      }
    }
}
