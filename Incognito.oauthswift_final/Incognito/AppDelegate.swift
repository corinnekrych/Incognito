//
//  AppDelegate.swift
//  Incognito
//
//  Created by Corinne Krych on 28/02/15.
//  Copyright (c) 2015 raywenderlich. All rights reserved.
//

import UIKit
import OAuthSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
    if (url.absoluteString.hasPrefix("com.raywenderlich.incognito:/oauth2Callback")) {
      OAuthSwift.handleOpenURL(url)
    }
    return true
  }
  
}

