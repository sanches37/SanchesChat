//
//  Color.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/06.
//

import SwiftUI

extension Color {
  static let _000000 = Color(hex: "000000")
  static let _FFFFFF = Color(hex: "FFFFFF")
  static let _FEE500 = Color(hex: "FEE500")
  static let _D3D3D3 = Color(hex: "D3D3D3")
  static let _BC8F8F = Color(hex: "BC8F8F")
  static let _4169E1 = Color(hex: "4169E1")
  static let _AFEEEE = Color(hex: "AFEEEE")
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
