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

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    var imagePicker = UIImagePickerController()
    var newMedia: Bool = true
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var glassesImage: UIImageView!
    
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
    
    @IBAction func handleHatMove(recognizer: UIPanGestureRecognizer) {
        //return
        let translation = recognizer.translationInView(self.view)
        recognizer.view!.center = CGPoint(x:recognizer.view!.center.x + translation.x,
            y:recognizer.view!.center.y + translation.y)
        recognizer.setTranslation(CGPointZero, inView: self.view)
    }
    
    @IBAction func pinchHat(recognizer: UIPinchGestureRecognizer) {
        recognizer.view!.transform = CGAffineTransformScale(recognizer.view!.transform,
            recognizer.scale, recognizer.scale)
        recognizer.scale = 1
    }
    
    @IBAction func rotateHat(recognizer: UIRotationGestureRecognizer) {
        recognizer.view!.transform = CGAffineTransformRotate(recognizer.view!.transform, recognizer.rotation)
        recognizer.rotation = 0

    }
    
    // MARK: - Menu Action
    
    @IBAction func showCamera(sender: AnyObject) {
        showCamera()
    }
    
    @IBAction func openCamera(sender: AnyObject) {
        openPhoto()
    }
    
    @IBAction func hide(sender: AnyObject) {
        let image = imageView.image!
        glassesImage.hidden = false
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
    
    private func showCamera() {
        if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera
            imagePicker.mediaTypes = NSArray(object: kUTTypeImage) as [AnyObject]
            
            self.presentViewController(imagePicker, animated:true, completion:{})
            newMedia = true
        } else {
            
        }
    }

}

