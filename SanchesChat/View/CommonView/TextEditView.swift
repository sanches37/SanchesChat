//
//  TextEditView.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/19.
//

import SwiftUI

struct TextEditorView: View {
  @Binding var text: String
  @State var textEditorHeight : CGFloat = .zero
  
  var body: some View {
    ZStack(alignment: .leading) {
      Text(text)
        .foregroundColor(.clear)
        .fontSize(16)
        .background(
          GeometryReader { geo -> Color in
            DispatchQueue.main.async {
              textEditorHeight = geo.size.height
            }
            return Color.clear
          }
        )
      
      TextEditor(text: $text)
        .fontSize(16)
        .frame(minHeight: 40)
        .frame(height: textEditorHeight)
    }
    .onAppear(perform: UIApplication.shared.hideKeyboard)
  }
}

extension UIApplication {
    func hideKeyboard() {
        guard let window = windows.first else { return }
        let tapRecognizer = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapRecognizer.cancelsTouchesInView = false
        tapRecognizer.delegate = self
        window.addGestureRecognizer(tapRecognizer)
    }
 }

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
