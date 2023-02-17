//
//  Color.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/06.
//

import SwiftUI

extension Color {
  static let goldenYellow = Color(hex: "FEE500")
  static let lightGray = Color(hex: "D3D3D3")
  static let rosyBrown = Color(hex: "BC8F8F")
  static let royalBlue = Color(hex: "4169E1")
  static let paleTurquoise = Color(hex: "AFEEEE")
}

extension Color {
  init(hex: String) {
    let lowerHex = hex.lowercased()
    let scanner = Scanner(string: lowerHex)
    _ = scanner.scanString("#")
    
    var rgb: UInt64 = 0
    scanner.scanHexInt64(&rgb)
    
    let r = Double((rgb >> 16) & 0xFF) / 255.0
    let g = Double((rgb >>  8) & 0xFF) / 255.0
    let b = Double((rgb >>  0) & 0xFF) / 255.0
    self.init(red: r, green: g, blue: b)
  }
}
