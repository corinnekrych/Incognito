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
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // TODO add http instance
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
    // 1 Create OAuth2Swift object
    let oauthswift = OAuth2Swift(
      consumerKey:    "213617875546-sq2e5jvm9qv2plfccc2n3un0c97gufld.apps.googleusercontent.com",         // 2 Enter google app settings
      consumerSecret: "",
      authorizeUrl:   "https://accounts.google.com/o/oauth2/auth",
      accessTokenUrl: "https://accounts.google.com/o/oauth2/token",
      responseType:   "code"
    )
    oauthswift.allowMissingStateCheck = true
    if #available(iOS 9.0, *) {
      oauthswift.authorize_url_handler = SafariURLHandler(viewController: self)
    } else {
      // Fallback on earlier versions, we use webwiew.
    }
    // 3 Trigger OAuth2 dance
    oauthswift.authorizeWithCallbackURL(
      NSURL(string: "com.raywenderlich.Incognito:/oauth2Callback")!,
      scope: "https://www.googleapis.com/auth/drive",        // 4 Scope
      state: "",
      success: { credential, response, parameters  in
        guard let snapshot = self.snapshot() else {return}
        let parameters =  [String: AnyObject]()
        // 5 Get the embedded http layer and upload
        oauthswift.client.postImage(
          "https://www.googleapis.com/upload/drive/v2/files",
          parameters: parameters,
          image: snapshot,
          success: { data, response in
            do {
            let _: AnyObject! = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
              self.presentAlert("Error", message: "Ooops some error processing JSON")
            }
            self.presentAlert("Success", message: "Successfully uploaded!")
          }, failure: {(error:NSError!) -> Void in
            self.presentAlert("Error", message: error!.localizedDescription)
        })
      }, failure: {(error:NSError!) -> Void in
        self.presentAlert("Error", message: error!.localizedDescription)
    })
  }
  
  // MARK: - UIImagePickerControllerDelegate
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    imagePicker.dismissViewControllerAnimated(true, completion: nil)
    imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
  }
  
  // MARK: - UIGestureRecognizerDelegate
  
  func gestureRecognizer(_: UIGestureRecognizer,
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
    let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
  }
  
  func snapshot() -> NSData? {
    UIGraphicsBeginImageContext(self.view.frame.size)
    guard let context = UIGraphicsGetCurrentContext() else {return nil}
    self.view.layer.renderInContext(context)
    let fullScreenshot = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    UIImageWriteToSavedPhotosAlbum(fullScreenshot, nil, nil, nil)
    return UIImageJPEGRepresentation(fullScreenshot, 0.5)
  }
  
}

