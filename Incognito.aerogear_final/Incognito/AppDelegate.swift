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
  
  func application(application: UIApplication,
    openURL url: NSURL,
    sourceApplication: String?,
    annotation: AnyObject) -> Bool {
      let notification = NSNotification(name: AGAppLaunchedWithURLNotification,
        object:nil,
        userInfo:[UIApplicationLaunchOptionsURLKey:url])
      NSNotificationCenter.defaultCenter().postNotification(notification)
      return true
  }
  
}

