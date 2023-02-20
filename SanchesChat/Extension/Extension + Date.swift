//
//  Extension + Date.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/20.
//

import Foundation

extension Date {
  func toDateTimeString(format: String = "yyyy년 MM월 dd일 E요일") -> String {
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
}
