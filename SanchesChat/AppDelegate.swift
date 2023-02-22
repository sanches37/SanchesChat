//
//  AppDelegate.swift
//  SanchesChat
//
//  Created by tae hoon park on 2023/02/22.
//

import Foundation
import SwiftUI
import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate {
  
  //앱이 실행됐을 때
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    
    //포그라운드 delegate
    UNUserNotificationCenter.current().delegate = self
    
    //메시지 delegate
    Messaging.messaging().delegate = self
    
    //원격 알림 등록
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(
      options: authOptions,
      completionHandler: { _, _ in }
    )
    application.registerForRemoteNotifications()
    
    return true
  }
  
  //APNs토큰을 fcm토큰과 연결
  func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      print(deviceToken)
      Messaging.messaging().apnsToken = deviceToken
  }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
  //앱이 켜져 있을 때 push message 올때
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      let userInfo = notification.request.content.userInfo
      print("willPresent", userInfo)
      completionHandler([.banner, .sound, .badge])
  }
  
  //push message를 받았을 때
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void) {
      let userInfo = response.notification.request.content.userInfo
      print("didReceive", userInfo)
      completionHandler()
  }
}

extension AppDelegate: MessagingDelegate {
  //fcm 등록 토큰을 받았을 때
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase registration token: \(String(describing: fcmToken))")
    
    let dataDict: [String: String] = ["token": fcmToken ?? ""]
    NotificationCenter.default.post(
      name: Notification.Name("FCMToken"),
      object: nil,
      userInfo: dataDict
    )
  }
}
