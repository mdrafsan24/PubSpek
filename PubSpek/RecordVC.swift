//
//  RecordVC.swift
//  PubSpek
//
//  Created by Rafsan Chowdhury on 5/26/17.
//  Copyright © 2017 Mcraf. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class RecordVC: UIViewController, FrameExtractorDelegate, AVAudioRecorderDelegate {
    
    @IBOutlet weak var resultBtn: RoundButton!
    @IBOutlet weak var startButton: RoundButton!
    @IBOutlet weak var imageView: UIImageView!
    var frameExtractor: FrameExtractor!
    var frameNumber = 1
    var grabNumber = 1
    var timer = Timer()
    var grabTimer = Timer()
    var startedRecording = false

    override func viewDidLoad() {
        super.viewDidLoad()
        frameExtractor = FrameExtractor()
        frameExtractor.delegate = self
        startButton.layer.borderWidth = 3
        startButton.layer.borderColor = UIColor.white.cgColor
        
    }
    func captured(image: UIImage) {
        imageView.image = image
    }
    
    func uploadFrame() {
        let storageRef = Storage.storage().reference().child("\(frameNumber)")
        frameNumber = frameNumber+1
        let data = UIImageJPEGRepresentation(imageView.image!, 0.8)
            storageRef.putData(data!, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(error as Any)
                    return
                }
            })
    }
    func analyzeFrame() {
        let storageRef = Storage.storage().reference().child("\(grabNumber)")
        grabNumber = grabNumber+1
        storageRef.downloadURL { url, error in
            if error != nil {
                print("ERROR DOWNLOADING URL")
            } else {
                VideoAnalysisService.instance.analyzeVideo(url: (url?.relativeString)!)
            }
        }
    }
    @IBAction func startRecording(_ sender: Any) {
        if (!startedRecording) {
            self.startButton.setTitle("Stop", for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.uploadFrame), userInfo: nil, repeats: true)
            grabTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.analyzeFrame), userInfo: nil, repeats: true)
            startedRecording = !startedRecording
        } else {
            timer.invalidate()
            grabTimer.invalidate()
            self.startButton.setTitle("Start", for: .normal)
            startedRecording = !startedRecording
            self.resultBtn.isHidden = false
        }
    }
    
}
