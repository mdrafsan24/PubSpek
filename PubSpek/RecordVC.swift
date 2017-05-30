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
    
    @IBOutlet weak var startButton: RoundButton!
    @IBOutlet weak var imageView: UIImageView!
    var frameExtractor: FrameExtractor!
    var frameNumber = Int()
    var grabNumber = Int()
    var timer = Timer()
    // var grabTimer = Timer() -> Real Time
    var startedRecording = false
    
    var recorder: AVAudioRecorder!
    
    private var voiceTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        frameNumber = 1
        grabNumber = 1
        frameExtractor = FrameExtractor()
        frameExtractor.delegate = self
        startButton.layer.borderWidth = 3
        startButton.layer.borderColor = UIColor.white.cgColor
        
        self.setupAudio()
    }
    
    
    
    func setupAudio() {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let fileName = "SpeechToText.wav"
        let filePath = NSURL(fileURLWithPath: documents + "/" + fileName)
        let session = AVAudioSession.sharedInstance()
        var settings = [String: Any]()
        settings[AVSampleRateKey] = NSNumber(floatLiteral: 44100.0)
        settings[AVNumberOfChannelsKey] = NSNumber(integerLiteral: 1)
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            recorder = try AVAudioRecorder(url: filePath as URL, settings: settings)
        } catch {
            // Do something
        }
        guard let recorder = recorder else {
            return
        }
        recorder.isMeteringEnabled = true
        recorder.prepareToRecord()
        
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
        while (grabNumber != frameNumber) { // Do some last minute checks 
            grabNumber = grabNumber+1
            storageRef.downloadURL { url, error in
                if error != nil {
                    print("ERROR DOWNLOADING URL")
                } else {
                    VideoAnalysisService.instance.analyzeVideo(url: (url?.relativeString)!)
                }
            }
        }
    }
    @IBAction func startRecording(_ sender: UIButton) {
        if (!startedRecording) {
            self.startButton.setTitle("Stop", for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.uploadFrame), userInfo: nil, repeats: true)
            //grabTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.analyzeFrame), userInfo: nil, repeats: true)
            startedRecording = !startedRecording
        } else {
            //self.frameExtractor.stopVideoCaptureSession()
            timer.invalidate()
            self.analyzeFrame()
            //grabTimer.invalidate()
            self.startButton.setTitle("Start", for: .normal)
            startedRecording = !startedRecording
        }
        
        if !recorder.isRecording {
            do {
                let session = AVAudioSession.sharedInstance()
                try session.setActive(true)
                recorder.record()
            } catch {}
        } else {
            do {
                recorder.stop()
                let session = AVAudioSession.sharedInstance()
                try session.setActive(false)
                
                SpeechToTextService.instance.speechToText(url: self.recorder.url)
                self.voiceTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true);
            } catch {}
        }
    }
    
    func update() {
        if (SpeechToTextService.instance.doneTranscribingSpeechToText()) {
            voiceTimer.invalidate()
            print(SpeechToTextService.instance.fullText)
            self.frameExtractor.stopVideoCaptureSession()
        }
    }

}
