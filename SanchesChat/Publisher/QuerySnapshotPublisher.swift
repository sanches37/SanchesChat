//
//  QuerySnapshotPublisher.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/11.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

extension Publishers {
  struct QuerySnapshotPublisher<T: Decodable>: Publisher {
    typealias Output = [T]
    typealias Failure = FirestoreError
    
    let query: Query
    
    func receive<S>(subscriber: S) where S : Subscriber, FirestoreError == S.Failure, [T] == S.Input {
      let querySnapshotSubscription = QuerySnapShotSubscription(subscriber: subscriber, query: query)
      subscriber.receive(subscription: querySnapshotSubscription)
    }
  }
  
  class QuerySnapShotSubscription<S: Subscriber, T: Decodable>: Subscription where S.Input == [T], S.Failure == FirestoreError {
    private var subscriber: S?
    private var listener: ListenerRegistration?
    
    init(subscriber: S, query: Query) {
      self.listener = query.addSnapshotListener { snapshot, error in
        if let error = error {
          subscriber.receive(completion: .failure(.unknown(description: error.localizedDescription)))
        }
        guard let snapshot = snapshot?.documents else {
          subscriber.receive(completion: .failure(.dataNotfound))
          return
        }
        do {
          let dataArray = try snapshot.compactMap {
            try $0.data(as: T.self)
          }
          _ = subscriber.receive(dataArray)
        } catch {
          subscriber.receive(completion: .failure(.decodingFailed))
        }
      }
    }
    
    func request(_ demand: Subscribers.Demand) {}
    
    func cancel() {
      subscriber = nil
      listener = nil
    }
  }
}
