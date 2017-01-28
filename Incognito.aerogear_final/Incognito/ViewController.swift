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
  
  var http: Http!
  override func viewDidLoad() {
    super.viewDidLoad()
    self.http = Http()
  }
  
  // MARK: - Gesture Action
  
  @IBAction func move(_ recognizer: UIPanGestureRecognizer) {
    //return
    let translation = recognizer.translation(in: self.view)
    recognizer.view!.center = CGPoint(x:recognizer.view!.center.x + translation.x,
      y:recognizer.view!.center.y + translation.y)
    recognizer.setTranslation(CGPoint.zero, in: self.view)
  }
  
  @IBAction func pinch(_ recognizer: UIPinchGestureRecognizer) {
    recognizer.view!.transform = recognizer.view!.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
    recognizer.scale = 1
  }
  
  @IBAction func rotate(_ recognizer: UIRotationGestureRecognizer) {
    recognizer.view!.transform = recognizer.view!.transform.rotated(by: recognizer.rotation)
    recognizer.rotation = 0
    
  }
  
  // MARK: - Menu Action
  
  @IBAction func openCamera(_ sender: AnyObject) {
    openPhoto()
  }
  
  @IBAction func hideShowHat(_ sender: AnyObject) {
    hatImage.isHidden = !hatImage.isHidden
  }
  
  @IBAction func hideShowGlasses(_ sender: AnyObject) {
    glassesImage.isHidden = !glassesImage.isHidden
  }
  
  @IBAction func hideShowMoustache(_ sender: AnyObject) {
    moustacheImage.isHidden = !moustacheImage.isHidden
  }
  
  @IBAction func share(_ sender: AnyObject) {
    let googleConfig = GoogleConfig(
      clientId: "213617875546-sq2e5jvm9qv2plfccc2n3un0c97gufld.apps.googleusercontent.com",                           // [1] Define a Google configuration
      scopes:["https://www.googleapis.com/auth/drive"])            // [2] Specify scope
    
    let gdModule = AccountManager.addGoogleAccount(config: googleConfig)   // [3] Add it to AccountManager
    self.http.authzModule = gdModule                               // [4] Inject the AuthzModule
    // into the HTTP layer object
    guard let snapshot = self.snapshot() else {
      self.presentAlert("Error", message: "Unable to snapshot the picture")
      return
    }
    let multipartData = MultiPartData(data: snapshot,       // [5] Define multi-part
      name: "image",
      filename: "incognito_photo",
      mimeType: "image/jpg")
    let multipartArray =  ["file": multipartData]
    
    self.http.request(method: .post, path: "https://www.googleapis.com/upload/drive/v2/files",   // [6] Upload image
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
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    imagePicker.dismiss(animated: true, completion: nil)
    imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
  }
  
  // MARK: - UIGestureRecognizerDelegate
  
  func gestureRecognizer(_: UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWith shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
      return true
  }
  
  // MARK: - Private functions
  
  fileprivate func openPhoto() {
    imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
    imagePicker.delegate = self
    present(imagePicker, animated: true, completion: nil)
  }
  
  func presentAlert(_ title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
  func snapshot() -> Data? {
    UIGraphicsBeginImageContext(self.view.frame.size)
    guard let context = UIGraphicsGetCurrentContext() else {return nil}
    self.view.layer.render(in: context)
    let fullScreenshot = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    UIImageWriteToSavedPhotosAlbum(fullScreenshot!, nil, nil, nil)
    return UIImageJPEGRepresentation(fullScreenshot!, 0.5)
  }
  
}

