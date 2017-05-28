//
//  ViewController.swift
//  PubSpek
//
//  Created by Rafsan Chowdhury on 5/13/17.
//  Copyright © 2017 Mcraf. All rights reserved.
//

import UIKit
import MobileCoreServices
import Firebase

class UploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var processingSpeech: UILabel!
    @IBOutlet weak var takePicture: UIButton!
    @IBOutlet weak var speechPic: UIImageView!
    @IBOutlet weak var continueBtnPic: RoundButton!
    @IBOutlet weak var tryAgainBtn: RoundButton!
    
    private var imagePicker: UIImagePickerController!
    private var timer: Timer!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.continueBtnPic.isHidden = true
        self.tryAgainBtn.isHidden = true
    }
    
    @IBAction func takePic(_ sender: Any) {
        self.takePicture.isHidden = true
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
        
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        self.imagePicker.allowsEditing = true
        // No need since we only want the photo 
        
        //self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: imagePicker.sourceType)!
        self.present(imagePicker, animated: true, completion: nil)
        
    }

    @IBAction func tryAgain(_ sender: Any) {
        self.speechPic.image = nil
        self.takePicture.isHidden = false
    }
    
    @IBAction func continuePressed(_ sender: Any) {
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
        self.speechPic.image = nil
        self.takePicture.isHidden = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as? String
        if mediaType == (kUTTypeImage as String) {
            // A PHOTO WAS TAKEN
            self.tryAgainBtn.isHidden = false // Enable Try Again Button
            self.processingSpeech.isHidden = false
            self.speechPic.image = info[UIImagePickerControllerOriginalImage] as? UIImage // CANT CAST AS EXPLICITLY
            let storageRef = Storage.storage().reference().child("Speech")
            let uploadData = UIImageJPEGRepresentation(self.speechPic.image!, 0.8) // Quality Of the Image is Here
            storageRef.putData(uploadData!, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(error!)
                    return
                }
                storageRef.downloadURL { url, error in
                    if error != nil {
                        print("ERROR DOWNLOADING URL")
                    } else {
                        TranscribeService.instance.transcribeSpeech(url: (url?.relativeString)!)
                        
                        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true);
                        print((url?.relativeString)!)
                    }
                }
            })
        } else {
            // A VIDEO WAS SHOT
        }
        
        // AFTER WE GOT THE IMAGE
        
        self.dismiss(animated: true, completion: nil)
    }
    func update() {
        if (TranscribeService.instance.transcribeDone()) {
            self.continueBtnPic.isHidden = false
            self.processingSpeech.isHidden = true
            self.timer.invalidate()
        }
    }

    
}

