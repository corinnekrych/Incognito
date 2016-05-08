//
//  WebViewController.swift
//  Incognito
//
//  Created by Scott Atkinson on 5/4/15.
//  Copyright (c) 2015 raywenderlich. All rights reserved.
//

import UIKit
import OAuthSwift

class WebViewController: OAuthWebViewController {
  var targetURL : NSURL = NSURL()
  var webView : UIWebView = UIWebView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    webView.frame = view.bounds
    webView.autoresizingMask =
      UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleHeight
    webView.scalesPageToFit = true
    view.addSubview(webView)
    loadAddressURL()
  }
  
  override func setUrl(url: NSURL) {
    targetURL = url
  }
  
  func loadAddressURL() {
    let req = NSURLRequest(URL: targetURL)
    webView.loadRequest(req)
  }
}
