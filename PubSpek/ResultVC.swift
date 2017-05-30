//
//  ResultVC.swift
//  PubSpek
//
//  Created by Rafsan Chowdhury on 5/26/17.
//  Copyright © 2017 Mcraf. All rights reserved.
//

import UIKit

class ResultVC: UIViewController {

    @IBOutlet weak var emotionYouNeedLBL: UILabel!
    @IBOutlet weak var wordsNeedToBeCarefulLbl: UILabel!
    /*
     Overall scoring system:
     If video emotion score is greater than document tone than its 100% accurate. Else just tell the user to show a little bit more of that emotion. 
     
    */
    
    private var videoDataInstance = VideoAnalysisData.instance
    private var documentDataInstance = ToneData.instance
    
    private var emotionsMissing = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Document happiness: ",  ToneData.instance.getDocumentTones())
        print("Video happiness: ", VideoAnalysisData.instance.getAverages())
        emotionYouNeedLBL.text = "You just needed to be a little bit more \(self.compareEmotion()). Other than that it was perfect!"
        wordsNeedToBeCarefulLbl.text = "Words you need to be careful with includes : \(cleanupMissingWords(missingWords: SpeechToTextService.instance.missingWords))"

    }
    
    func compareEmotion() -> String {
        if (videoDataInstance.getAverages()["happiness"]! < documentDataInstance.getDocumentTones()["Joy"]! && documentDataInstance.getDocumentTones()["Joy"]! > 0.2) {
            emotionsMissing.append("Happiness")
        }
        if (videoDataInstance.getAverages()["anger"]! < documentDataInstance.getDocumentTones()["Anger"]! && documentDataInstance.getDocumentTones()["Anger"]! > 0.2) {
            emotionsMissing.append("Angry")
        }
        if (videoDataInstance.getAverages()["fear"]! < documentDataInstance.getDocumentTones()["Fear"]! && documentDataInstance.getDocumentTones()["Fear"]! > 0.2) {
            emotionsMissing.append("Fearful")
        }
        if (videoDataInstance.getAverages()["sadness"]! < documentDataInstance.getDocumentTones()["Sadness"]! && documentDataInstance.getDocumentTones()["Sadness"]! > 0.2) {
            emotionsMissing.append("Sad")
        }
        if (videoDataInstance.getAverages()["disgust"]! < documentDataInstance.getDocumentTones()["Disgust"]! && documentDataInstance.getDocumentTones()["Disgust"]! > 0.2) {
            emotionsMissing.append("Disgust")
        }
        
        return emotionsMissing.joined(separator: ", ")
    }
    
    
    func cleanupMissingWords(missingWords: [String]) -> String {
        
        // Check to make sure this is the right way
        var missingWords = missingWords.joined(separator: ", ").trimmingCharacters(in: .whitespaces)
        
        let badChars = [ "/", ".", ";" ]
        
        for char in badChars {
            missingWords = missingWords.replacingOccurrences(of: char, with: "")
        }
        
        return missingWords
        
    }
}
