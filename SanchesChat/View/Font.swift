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
  var fontSize8: some View {
    self.modifier(Font(size: 8))
  }
  
  var fontSize10: some View {
    self.modifier(Font(size: 10))
  }
  
  var fontSize12: some View {
    self.modifier(Font(size: 12))
  }
  
  var fontSize14: some View {
    self.modifier(Font(size: 14))
  }
  
  var fontSize16: some View {
    self.modifier(Font(size: 16))
  }
  
  var fontSize18: some View {
    self.modifier(Font(size: 18))
  }
  
  var fontSize20: some View {
    self.modifier(Font(size: 20))
  }
}
