//
//  SpeechToTextService.swift
//  PubSpek
//
//  Created by Rafsan Chowdhury on 5/27/17.
//  Copyright © 2017 Mcraf. All rights reserved.
//

import Foundation
import Alamofire
import Firebase
import SpeechToTextV1
import Alamofire
import RestKit

class SpeechToTextService {
    static let instance = SpeechToTextService()
    private var _fullText = ""
    private var _missingWords = [String]() // Speech audio version
    
    var missingWords: [String] {
        get {
            if _missingWords.count > 0 {
                return _missingWords
            }
            return [String]()
        }
    }
    
    var fullText: String {
        get {
            return _fullText
        }
    }
    
    func speechToText(url : URL) {
        let speechToText = SpeechToText(username: "2110996b-05d3-452a-9377-36b0857db63f", password: "T6Rb76kKH4cP")
        let settings = RecognitionSettings(contentType: .wav)
        //settings.interimResults = true
        _ = { (error: Error) in print(error) }
        speechToText.recognize(audio: url, settings: settings, success: { (SpeechRecognitionResults) in
            self._fullText = SpeechRecognitionResults.bestTranscript
            speechToText.stopRecognizeMicrophone()
        })
    }
    
    func doneTranscribingSpeechToText() -> Bool {
        if (_fullText.characters.count > 10) {
            prepareSets()
            return true
        }
        return false
    }
    
    func prepareSets() {
        /*
         Needs fixation. Make sure the algorithms properly identifies all the words mispronounced or missing
         */
        
        let transcribedSpeech = TextAnalysisService.instance.editedSpeech.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "").lowercased()
        let voiceSpeech = _fullText.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "").lowercased()
        var transcribedSpeechArr = transcribedSpeech.components(separatedBy: " ")
        let voiceSpeechArr = voiceSpeech.components(separatedBy: " ")
        
        for word in transcribedSpeechArr {
            if voiceSpeechArr.contains(word) {
                transcribedSpeechArr.remove(at: transcribedSpeechArr.index(of: word)!)
            }
        }
        _missingWords = transcribedSpeechArr
    }
}
