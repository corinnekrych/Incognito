//
//  ViewController.swift
//  Incognito
//
//  Created by Corinne Krych on 28/02/15.
//  Copyright (c) 2015 raywenderlich. All rights reserved.
//

import UIKit
import MobileCoreServices
import AssetsLibrary

import OAuthSwift

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
  var imagePicker = UIImagePickerController()
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var hatImage: UIImageView!
  @IBOutlet weak var glassesImage: UIImageView!
  @IBOutlet weak var moustacheImage: UIImageView!
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - Gesture Action
  
  @IBAction func move(recognizer: UIPanGestureRecognizer) {
    //return
    let translation = recognizer.translationInView(self.view)
    recognizer.view!.center = CGPoint(x:recognizer.view!.center.x + translation.x,
      y:recognizer.view!.center.y + translation.y)
    recognizer.setTranslation(CGPointZero, inView: self.view)
  }
  
  @IBAction func pinch(recognizer: UIPinchGestureRecognizer) {
    recognizer.view!.transform = CGAffineTransformScale(recognizer.view!.transform,
      recognizer.scale, recognizer.scale)
    recognizer.scale = 1
  }
  
  @IBAction func rotate(recognizer: UIRotationGestureRecognizer) {
    recognizer.view!.transform = CGAffineTransformRotate(recognizer.view!.transform, recognizer.rotation)
    recognizer.rotation = 0
    
  }
  
  // MARK: - Menu Action
  
  @IBAction func openCamera(sender: AnyObject) {
    openPhoto()
  }
  
  @IBAction func hideShowHat(sender: AnyObject) {
    hatImage.hidden = !hatImage.hidden
  }
  
  @IBAction func hideShowGlasses(sender: AnyObject) {
    glassesImage.hidden = !glassesImage.hidden
  }
  
  @IBAction func hideShowMoustache(sender: AnyObject) {
    moustacheImage.hidden = !moustacheImage.hidden
  }
  
  @IBAction func share(sender: AnyObject) {
    let oauthswift = OAuth2Swift(
      consumerKey:    "20090539836-ule17ijdem41cbqm9ir4dlc1n4p7c3jn.apps.googleusercontent.com",         // [1] Enter google app settings
      consumerSecret: "ssRlrs-w0YNj0jq0XsCoJgHT",
      authorizeUrl:   "https://accounts.google.com/o/oauth2/auth",
      accessTokenUrl: "https://accounts.google.com/o/oauth2/token",
      responseType:   "code"
    )
    
    oauthswift.webViewController = WebViewController()

    // [2] Trigger OAuth2 dance
    oauthswift.authorizeWithCallbackURL(
      NSURL(string: "com.raywenderlich.Incognito:/oauth2Callback")!,
      scope: "https://www.googleapis.com/auth/drive",        // [3] Scope
      state: "",
      success: { credential, response in
        var parameters =  [String: AnyObject]()
        // [4] Get the embedded http layer and upload
        oauthswift.client.postImage(
          "https://www.googleapis.com/upload/drive/v2/files",
          parameters: parameters,
          image: self.snapshot(),
          success: { data, response in
            let jsonDict: AnyObject! = NSJSONSerialization.JSONObjectWithData(data,
              options: nil,
              error: nil)
            self.presentAlert("Success", message: "Successfully uploaded!")
          }, failure: {(error:NSError!) -> Void in
            self.presentAlert("Error", message: error!.localizedDescription)
        })
      }, failure: {(error:NSError!) -> Void in
        self.presentAlert("Error", message: error!.localizedDescription)
    })
  }
  
  // MARK: - UIImagePickerControllerDelegate
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    imagePicker.dismissViewControllerAnimated(true, completion: nil)
    imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
  }
  
  // MARK: - UIGestureRecognizerDelegate
  
  func gestureRecognizer(UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
      return true
  }
  
  // MARK: - Private functions
  
  private func openPhoto() {
    imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
    imagePicker.delegate = self
    presentViewController(imagePicker, animated: true, completion: nil)
  }
  
  func presentAlert(title: String, message: String) {
    var alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
  }
  
  func snapshot() -> NSData {
    UIGraphicsBeginImageContext(self.view.frame.size)
    self.view.layer.renderInContext(UIGraphicsGetCurrentContext())
    let fullScreenshot = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    UIImageWriteToSavedPhotosAlbum(fullScreenshot, nil, nil, nil)
    return UIImageJPEGRepresentation(fullScreenshot, 0.5)
  }
  
}

