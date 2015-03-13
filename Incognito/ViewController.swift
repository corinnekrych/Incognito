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
    var newMedia: Bool = true
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
        println("Perform photo upload with Google")
        
        doOAuthTwitter()

        //self.performUpload("https://www.googleapis.com/upload/drive/v2/files", parameters: self.extractImageAsMultipartParams())
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
    
    func doOAuthTwitter() {
        let oauthswift = OAuth1Swift(
            consumerKey:    "aTaSn8tBgQhSKSLotaPWnC0w7",
            consumerSecret: "fvyCKCECrDXUqBtDGmgbxuXt2fhlsq2Feb18pSvpoF3zWIpoAP",
            requestTokenUrl: "https://api.twitter.com/oauth/request_token",
            authorizeUrl:    "https://api.twitter.com/oauth/authorize",
            accessTokenUrl:  "https://api.twitter.com/oauth/access_token"
        )
        
        //oauthswift.webViewController = WebViewController()
        oauthswift.authorizeWithCallbackURL( NSURL(string: "oauth-swift://oauth-callback/twitter")!, success: {
            credential, response in
            
            var parameters =  [String: AnyObject]()
            parameters["status"] = "hello"
            oauthswift.client.post("https://api.twitter.com/1.1/statuses/update.json", parameters: parameters,
                success: {
                    data, response in
                    let jsonDict: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil)
                    println(jsonDict)
                }, failure: {(error:NSError!) -> Void in
                    println(error)
            })
            
            // failure in authz
            }, failure: {(error:NSError!) -> Void in
                println(error.localizedDescription)
            }
        )
    }
    
    func showAlertView(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    private func openPhoto() {
        imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func performUpload(url: String, parameters: [String: AnyObject]?) {
//        self.http.POST(url, parameters: parameters, completionHandler: {(response, error) in
//            if (error != nil) {
//                self.presentAlert("Error", message: error!.localizedDescription)
//            } else {
//                self.presentAlert("Success", message: "Successfully uploaded!")
//            }
//        })
    }
    
    func presentAlert(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
//    
//    func extractImageAsMultipartParams() -> [String: AnyObject] {
//        UIGraphicsBeginImageContext(self.view.frame.size)
//        self.view.layer.renderInContext(UIGraphicsGetCurrentContext())
//        let fullScreenshot = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        UIImageWriteToSavedPhotosAlbum(fullScreenshot, nil, nil, nil)
//
//        let multiPartData = MultiPartData(data: UIImageJPEGRepresentation(fullScreenshot, 0.5),
//            name: "image",
//            filename: "incognito_photo",
//            mimeType: "image/jpg")
//        
//        return ["file": multiPartData]
//    }

}

