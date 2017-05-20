//
//  ReviewVC.swift
//  PubSpek
//
//  Created by Rafsan Chowdhury on 5/19/17.
//  Copyright © 2017 Mcraf. All rights reserved.
//

import UIKit

class ReviewVC: UIViewController {

    @IBOutlet weak var transcribedText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.transcribedText.text = TranscribeService.instance.getTranscribedText
        
    }
    @IBAction func continuePressed(_ sender: Any) {
        // Means speech was okay, analyze emotions now
        TextAnalysisService.instance.analyzeEmotions(speech: transcribedText.text)
        
    }

    

}
