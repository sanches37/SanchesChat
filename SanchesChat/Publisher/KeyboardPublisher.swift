//
//  KeyboardPublisher.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/20.
//

import Combine
import SwiftUI

extension View {
  var keyboardPublisher: AnyPublisher<Bool, Never> {
    Publishers
      .Merge(
        NotificationCenter
          .default
          .publisher(for: UIResponder.keyboardWillShowNotification)
          .map { _ in true },
        NotificationCenter
          .default
          .publisher(for: UIResponder.keyboardWillHideNotification)
          .map { _ in false })
      .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
      .eraseToAnyPublisher()
  }
}
