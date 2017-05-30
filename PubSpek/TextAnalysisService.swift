//
//  TextAnalysisService.swift
//  PubSpek
//
//  Created by Rafsan Chowdhury on 5/19/17.
//  Copyright © 2017 Mcraf. All rights reserved.
//

import Foundation
import ToneAnalyzerV3
import RestKit

class TextAnalysisService {
    private var apiKey = "c690ef0910c6a4928c4d98245d6c3015ab8bca0d"
    private var username = "b64c9a34-00d6-48ab-b252-daf4d4ce05c5"
    private var password = "yWM5gHvR22hw"
    private var version = "2017-05-19" // use today's date for the most recent version
    
    private var _editedSpeech: String!
    
    var editedSpeech: String {
        get {
            return _editedSpeech
        }
    }
    
    static let instance = TextAnalysisService()
    
    // Used to Analyze Tones 
    func analyzeEmotions (speech: String) {
        self._editedSpeech = speech // Sets the speech to edited speech 
        let failure = { (error: RestError) in print(error) }
        let toneAnalyzer = ToneAnalyzer(username: self.username, password: password, version: version)

        toneAnalyzer.getTone(ofText: speech, failure: failure as? ((Error) -> Void)) { tones in
            
            if let toneArray = tones.documentTone as? [ToneCategory] {
                for toneScore in toneArray {
                    if let toneScore = toneScore.tones as? [ToneScore] {
                        for tone in toneScore {
                            ToneData.instance.addDocumentTone(documentTone: tone.name, documentToneScore: tone.score)
                        }
                    }
                }
            }

            if let toneSentenceArray = tones.sentencesTones {
                for tone in toneSentenceArray {
                    if let sentenceTones = tones.sentencesTones {
                        if let toneCategory = sentenceTones[tone.sentenceID].toneCategories as? [ToneCategory] {
                            for tones in toneCategory {
                                for toneScore in tones.tones {
                                    ToneData.instance.addSentenceTone(sentence: tone.text, tone: toneScore.name, score: toneScore.score)
                                }
                            }
                        }
                    }
                }
            }
        }
    
    }
    
    
    
    
    
}
