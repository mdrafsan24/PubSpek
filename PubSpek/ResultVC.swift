//
//  ResultVC.swift
//  PubSpek
//
//  Created by Rafsan Chowdhury on 5/26/17.
//  Copyright © 2017 Mcraf. All rights reserved.
//

import UIKit

class ResultVC: UIViewController {

    @IBOutlet weak var emotionYouNeedLBL: UITextView!
    @IBOutlet weak var wordsNeedToBeCarefulLbl: UITextView!
    /*
     Overall scoring system:
     If video emotion score is greater than document tone than its 100% accurate. Else just tell the user to show a little bit more of that emotion. 
     
     Percentage System: 
     
     Emotion : 60%
     Pronounciation: 40%
     
    */
    
    private var videoDataInstance = VideoAnalysisData.instance
    private var documentDataInstance = ToneData.instance
    
    private var emotionsMissing = [String]()
    
    private var emotionPercent = 60
    private var wordPercent = 40

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reset()
        print("Document happiness: ",  ToneData.instance.getDocumentTones())
        print("Video happiness: ", VideoAnalysisData.instance.getAverages())
        
        self.emotionYouNeedLBL.text = self.overallEmotionComment()
        let missingWords = self.cleanupMissingWords(missingWords: SpeechToTextService.instance.missingWords)
        if (missingWords.characters.count != 0) {
            wordsNeedToBeCarefulLbl.text = "Words you need to be careful with includes : \(missingWords)"
        } else {
            wordsNeedToBeCarefulLbl.text = "Your pronounciation is on point! Great Job!"
        }
        ProgressDetails.instance.progress = emotionPercent + wordPercent
        
        VideoAnalysisData.instance.reset()

    }
    
    func reset() {
        emotionsMissing = [String]()
        emotionPercent = 60
        wordPercent = 40
    }
    
    func compareEmotion() -> [String] {
        if (videoDataInstance.getAverages()["happiness"]! < documentDataInstance.getDocumentTones()["Joy"]! && documentDataInstance.getDocumentTones()["Joy"]! > 0.10) {
            emotionsMissing.append("Happy")
        }
        if (videoDataInstance.getAverages()["anger"]! < documentDataInstance.getDocumentTones()["Anger"]! && documentDataInstance.getDocumentTones()["Anger"]! > 0.10) {
            emotionsMissing.append("Angry")
        }
        if (videoDataInstance.getAverages()["fear"]! < documentDataInstance.getDocumentTones()["Fear"]! && documentDataInstance.getDocumentTones()["Fear"]! > 0.10) {
            emotionsMissing.append("Fearful")
        }
        if (videoDataInstance.getAverages()["sadness"]! < documentDataInstance.getDocumentTones()["Sadness"]! && documentDataInstance.getDocumentTones()["Sadness"]! > 0.10) {
            emotionsMissing.append("Sad")
        }
        if (videoDataInstance.getAverages()["disgust"]! < documentDataInstance.getDocumentTones()["Disgust"]! && documentDataInstance.getDocumentTones()["Disgust"]! > 0.10) {
            emotionsMissing.append("Disgusted")
        }
        
        return self.emotionsMissing
        
        //return emotionsMissing.joined(separator: ", ")
    }
    
    func cleanupMissingWords(missingWords: [String]) -> String {
        // Check to make sure this is the right way
        if (missingWords.count >= 20) {
            self.wordPercent = self.wordPercent - 40
            return "Way too many, either you didn't speak louadly enough, had too much background noise or got something in your mouth..."
        }
        if (missingWords.count >= 15 && missingWords.count < 20) {
            self.wordPercent = self.wordPercent - 30
        }
        if (missingWords.count >= 10 && missingWords.count < 15) {
            self.wordPercent = self.wordPercent - 20
        }
        if (missingWords.count >= 5 && missingWords.count < 10) {
            self.wordPercent = self.wordPercent - 10
        }
        if (missingWords.count > 0 && missingWords.count < 5) {
            self.wordPercent = self.wordPercent - 5
        }
        
        var missingWords = missingWords.joined(separator: ", ").trimmingCharacters(in: .whitespaces)
        
        let badChars = [ "/", ".", ";", ")", "(", "-", "!", "'", "_"]
        
        for char in badChars {
            missingWords = missingWords.replacingOccurrences(of: char, with: "")
        }
        
        return missingWords
    }
    
    func overallEmotionComment() -> String {
        var overallCommentary = String()
        let emotionMissingArr = self.compareEmotion()
        if (videoDataInstance.getAverages()["neutral"]! >= 0.90) {
            overallCommentary = overallCommentary + "You look very emotionless while you speak, try to be more passionate. "
            self.emotionPercent = 0
            return overallCommentary
        } else if (emotionMissingArr.isEmpty && videoDataInstance.getAverages()["neutral"]! < 0.60){
            overallCommentary = "Hey that was perfect! Your expressions are on point!"
            self.emotionPercent = 60
            return overallCommentary
        }
        for emotion in emotionMissingArr {
            var differenceInEmotion = 0.0
            switch emotion {
            case "Happy":
                differenceInEmotion = abs(videoDataInstance.getAverages()["happiness"]!-documentDataInstance.getDocumentTones()["Joy"]!)
            case "Angry":
                differenceInEmotion = abs(videoDataInstance.getAverages()["anger"]!-documentDataInstance.getDocumentTones()["Anger"]!)
            case "Fearful":
                differenceInEmotion = abs(videoDataInstance.getAverages()["fear"]!-documentDataInstance.getDocumentTones()["Fear"]!)
            case "Sad":
                differenceInEmotion = abs(videoDataInstance.getAverages()["sadness"]!-documentDataInstance.getDocumentTones()["Sadness"]!)
            case "Disgusted":
                differenceInEmotion = abs(videoDataInstance.getAverages()["disgust"]!-documentDataInstance.getDocumentTones()["Disgust"]!)
            default: ()
                
            }
            
            if (differenceInEmotion >= 0.60) {
                overallCommentary = overallCommentary + "You need to be way more \(emotion.lowercased()). "
                self.emotionPercent = self.emotionPercent - 12

            }
            if (differenceInEmotion >= 0.35 && differenceInEmotion < 0.60) {
                overallCommentary = overallCommentary + "You need to be a bit more \(emotion.lowercased()). "
                self.emotionPercent = self.emotionPercent - 8
            }
            if (differenceInEmotion >= 0.10 && differenceInEmotion < 0.35) {
                overallCommentary = overallCommentary + "Act a tidbit more \(emotion.lowercased()). "
                self.emotionPercent = self.emotionPercent - 4
            }
            if (differenceInEmotion >= 0.0 && differenceInEmotion < 0.10) {
                overallCommentary = overallCommentary + "Your \(emotion.lowercased())self is on point though!"
                self.emotionPercent = self.emotionPercent - 4
            }
           
        }
        return overallCommentary
    }
}
