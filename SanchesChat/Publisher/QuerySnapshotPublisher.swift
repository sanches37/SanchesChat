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
    
    let query: FirestoreCollecion
    
    func receive<S>(subscriber: S) where S : Subscriber, FirestoreError == S.Failure, [T] == S.Input {
      let querySnapshotSubscription = QuerySnapShotSubscription(subscriber: subscriber, query: query)
      subscriber.receive(subscription: querySnapshotSubscription)
    }
  }
  
  class QuerySnapShotSubscription<S: Subscriber, T: Decodable>: Subscription where S.Input == [T], S.Failure == FirestoreError {
    private var subscriber: S?
    private var listener: ListenerRegistration?
    
    init(subscriber: S, query: FirestoreCollecion) {
      self.listener = query.path.addSnapshotListener {
        switch query.getProcess(T.self, $0, $1) {
        case let .success(result):
          _ = subscriber.receive(result)
        case let .failure(error):
          subscriber.receive(completion: .failure(error))
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
