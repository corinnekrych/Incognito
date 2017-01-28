//
//  AppDelegate.swift
//  Incognito
//
//  Created by Corinne Krych on 28/02/15.
//  Copyright (c) 2015 raywenderlich. All rights reserved.
//

import UIKit
import AeroGearOAuth2

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication,
    open url: URL,
    sourceApplication: String?,
    annotation: Any) -> Bool {
      let notification = Notification(name: Notification.Name(rawValue: AGAppLaunchedWithURLNotification),
        object:nil,
        userInfo:[UIApplicationLaunchOptionsKey.url:url])
      NotificationCenter.default.post(notification)
      return true
  }
  
}

