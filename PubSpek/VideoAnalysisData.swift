//
//  VideoAnalysisData.swift
//  PubSpek
//
//  Created by Rafsan Chowdhury on 5/29/17.
//  Copyright © 2017 Mcraf. All rights reserved.
//

import Foundation
import SwiftyJSON

class VideoAnalysisData {
    
    private var anger = [Double]()
    private var contempt = [Double]()
    private var disgust = [Double]()
    private var fear = [Double]()
    private var happiness = [Double]()
    private var neutral = [Double]()
    private var sadness = [Double]()
    private var surprise = [Double]()
    
    static let instance = VideoAnalysisData()
    
    private var _numScores = 0
    
    var numScores: Int {
        get {
            return _numScores
        }
    }
    
    func addScores (json: JSON) {
        _numScores += 1
        if (!json.isEmpty) {
            // Just to make sure we dont have nil
            let scores = json[0]["scores"]
            self.anger.append(scores["anger"].double!)
            self.contempt.append(scores["contempt"].double!)
            self.disgust.append(scores["disgust"].double!)
            self.fear.append(scores["fear"].double!)
            self.happiness.append(scores["happiness"].double!)
            self.neutral.append(scores["neutral"].double!)
            self.sadness.append(scores["sadness"].double!)
            self.surprise.append(scores["surprise"].double!)

        }
    }
    
    func getAverages() -> Dictionary <String, Double> {
        let emotions = [self.anger, self.fear, self.happiness, self.neutral, self.sadness ]
        for emotion in emotions {
            var emotion = emotion
            for e in emotion {
                if (e < 0.10) {
                    emotion.remove(at: emotion.index(of: e)!)
                }
            }
        }
        return [ "anger" : anger.reduce(0, +)/Double(anger.count),
                 "contempt" : contempt.reduce(0, +)/Double(contempt.count),
                 "disgust" : disgust.reduce(0, +)/Double(disgust.count),
                 "fear" : fear.reduce(0, +)/Double(fear.count),
                 "happiness" : happiness.reduce(0, +)/Double(happiness.count),
                 "neutral" : neutral.reduce(0, +)/Double(neutral.count),
                 "sadness" : sadness.reduce(0, +)/Double(sadness.count),
                 "surprise" : surprise.reduce(0, +)/Double(surprise.count)
        ]
    }
    
    func reset() {
        anger.removeAll()
        disgust.removeAll()
        fear.removeAll()
        happiness.removeAll()
        neutral.removeAll()
        sadness.removeAll()
    }
    
}
