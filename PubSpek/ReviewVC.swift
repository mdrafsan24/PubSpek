//
//  ReviewVC.swift
//  PubSpek
//
//  Created by Rafsan Chowdhury on 5/19/17.
//  Copyright © 2017 Mcraf. All rights reserved.
//

import UIKit

class ReviewVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var transcribedText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Switch All Occurences of / and other unnecessary characters 
        self.transcribedText.text = TranscribeService.instance.getTranscribedText.replacingOccurrences(of: "/", with: "I")
        transcribedText.delegate = self
    }
    
    @IBAction func continuePressed(_ sender: Any) {
        // Means speech was okay, analyze emotions now
        print(self.transcribedText.text)
        TextAnalysisService.instance.analyzeEmotions(speech: self.transcribedText.text)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.transcribedText.text = textView.text
    }
}
