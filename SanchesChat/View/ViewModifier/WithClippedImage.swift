//
//  WithClippedFileImage.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/15.
//

import SwiftUI

struct AnyShape: Shape {
  private let _path: (CGRect) -> Path
  
  init<S: Shape>(_ wrapped: S) {
    _path = { rect in
      let path = wrapped.path(in: rect)
      return path
    }
  }
  
  func path(in rect: CGRect) -> Path {
    return _path(rect)
  }
}

enum ClippedType {
  case circle
  case rectangle
  case roundedRectangle(cornerRadius: CGFloat)
  
  var value: some Shape {
    switch self {
    case .circle:
      return AnyShape(Circle())
    case .rectangle:
      return AnyShape(Rectangle())
    case .roundedRectangle(let cornerRadius):
      return AnyShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
  }
}

struct WithClippedImageViewModifier: ViewModifier {
  let width: CGFloat?
  let height: CGFloat?
  let clippedType: ClippedType
  
  func body(content: Content) -> some View {
    content
      .scaledToFill()
      .frame(width: width, height: height)
      .clipShape(clippedType.value)
      .contentShape(clippedType.value)
  }
}

extension View {
  func withClippedImage(
    width: CGFloat? = nil,
    height: CGFloat? = nil,
    clippedType: ClippedType) -> some View {
      modifier(WithClippedImageViewModifier(
        width: width,
        height: height,
        clippedType: clippedType)
      )
    }
}


