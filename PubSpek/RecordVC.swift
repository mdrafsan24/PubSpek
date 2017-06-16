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
    
    @IBOutlet weak var spekMagicProcessLBL: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    var frameExtractor: FrameExtractor!
    var frameNumber = Int()
    var grabNumber = Int()
    var timer = Timer()

    var startedRecording = false
    
    var recorder: AVAudioRecorder!
    
    private var voiceTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
        
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.reset()
    }
    
    func reset() {
        self.startButton.isHidden = false
        frameNumber = 1
        grabNumber = 1
        frameExtractor = FrameExtractor()
        frameExtractor.delegate = self
        self.setupAudio()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
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
        let userId = RandomID.instance.userId
        let storageRef = Storage.storage().reference().child("\(userId)-\(frameNumber)")
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
        let userId = RandomID.instance.userId
        let storageRef = Storage.storage().reference().child("\(userId)-\(grabNumber)")
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
            self.startButton.setImage(UIImage(named: "CameraIconRecording2"), for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.uploadFrame), userInfo: nil, repeats: true)
            startedRecording = !startedRecording
        } else {
            self.startButton.setImage(UIImage(named: "CameraIcon2"), for: .normal)
            self.startButton.isHidden = true
            self.spekMagicProcessLBL.isHidden = false
            timer.invalidate()
            self.analyzeFrame()
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
    
    /*
     @ param: none
     @ task: checks to make sure whether our voice output has been fully transcribed or not, when its done, we move on
     */
    func update() {
        if (SpeechToTextService.instance.doneTranscribingSpeechToText() && VideoAnalysisService.instance.doneAnalyzing()) {
            voiceTimer.invalidate()
            print(SpeechToTextService.instance.fullText)
            self.spekMagicProcessLBL.isHidden = true
            performSegue(withIdentifier: "goToResult", sender: self)
            self.frameExtractor.stopVideoCaptureSession()
        }
    }

}
