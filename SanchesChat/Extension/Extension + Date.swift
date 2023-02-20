//
//  Extension + Date.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/20.
//

import Foundation

extension Date {
  func toDateTimeString(format: String = "yyyy년 MM월 dd일") -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    formatter.locale = Locale(identifier: "ko_KR")
    return formatter.string(from: self)
  }
  
  func checkIsSameDay(compareTo: Date) -> Bool {
    let calendar = Calendar.current
    let lhsDay = calendar.dateComponents([.day], from: self)
    let rhsDay = calendar.dateComponents([.day], from: compareTo)
    return lhsDay == rhsDay
  }
  
  func toRelativeString() -> String {
    let today = Date()
    guard let interval = Calendar.current.dateComponents([.day], from: self, to: today).day,
          interval != 0 else {
      return toDateTimeString(format: "a hh:mm")
    }
    
    let currentYEAR = "2023"
    if self.toString().contains(currentYEAR) {
      return toDateTimeString(format: "MM월 dd일")
    } else {
      return self.toDateTimeString()
    }
  }
}
