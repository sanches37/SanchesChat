//
//  Font'.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/06.
//

import SwiftUI

struct Font: ViewModifier {
  let size: CGFloat
  
  func body(content: Content) -> some View {
    content
      .font(.system(size: self.size))
  }
}

extension View {
  func fontSize(_ size: CGFloat) -> some View {
    self.modifier(Font(size: size))
  }
}
