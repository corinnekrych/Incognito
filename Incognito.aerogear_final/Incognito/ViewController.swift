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

import AeroGearHttp
import AeroGearOAuth2

// TODO add import

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
  
  var http: Http!
  override func viewDidLoad() {
    super.viewDidLoad()
    self.http = Http()
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
    let googleConfig = GoogleConfig(
      clientId: "YOUR_GOOGLE_CLIENT_ID",                           // [1] Define a Google configuration
      scopes:["https://www.googleapis.com/auth/drive"])            // [2] Specify scope
    
    let gdModule = AccountManager.addGoogleAccount(googleConfig)   // [3] Add it to AccountManager
    self.http.authzModule = gdModule                               // [4] Inject the AuthzModule
    // into the HTTP layer object
    
    let multipartData = MultiPartData(data: self.snapshot(),       // [5] Define multi-part
      name: "image",
      filename: "incognito_photo",
      mimeType: "image/jpg")
    let multipartArray =  ["file": multipartData]
    
    self.http.POST("https://www.googleapis.com/upload/drive/v2/files",   // [6] Upload image
      parameters: multipartArray,
      completionHandler: {(response, error) in
        if (error != nil) {
          self.presentAlert("Error", message: error!.localizedDescription)
        } else {
          self.presentAlert("Success", message: "Successfully uploaded!")
        }
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

