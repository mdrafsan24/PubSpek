//
//  ToneAnalyze.swift
//  PubSpek
//
//  Created by Rafsan Chowdhury on 5/19/17.
//  Copyright © 2017 Mcraf. All rights reserved.
//

import Foundation
import Alamofire
import Firebase

public class ToneData {
    private var documentTones = [String : Double]()

    private var sentetnceTones = [[String : Any]]()
    // Think whether dictionary is appropriate in this case
    
    static let instance = ToneData()
    
    func addDocumentTone (documentTone: String, documentToneScore: Double) {
        self.documentTones[documentTone] = documentToneScore
    }
    
    /* Fix the data structure, may need to have the sentence as the key */
    func addSentenceTone (sentence: String, tone: String, score: Double) {
        sentetnceTones.append([tone: ["sentence" : sentence, "score": score]])
    }
    
    func getDocumentTones() -> [String: Double]  {
        if self.documentTones.count > 0 {
            return self.documentTones
        }
        return [String: Double]()
    }
    
    /*func printTone() {
        for tone in self.documentTones {
            print(tone)
        }
        for sTone in sentetnceTones {
            print(sTone)
        }
    }*/
}
