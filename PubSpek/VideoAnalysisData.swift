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
    
    func addScores (json: JSON) {
        if (!json.isEmpty) {
            self.anger.append(json[0]["scores"]["anger"].double!)
            self.contempt.append(json[0]["scores"]["contempt"].double!)
            self.disgust.append(json[0]["scores"]["disgust"].double!)
            self.fear.append(json[0]["scores"]["fear"].double!)
            self.happiness.append(json[0]["scores"]["happiness"].double!)
            self.neutral.append(json[0]["scores"]["neutral"].double!)
            self.sadness.append(json[0]["scores"]["sadness"].double!)
            self.surprise.append(json[0]["scores"]["surprise"].double!)
        }
    }
    
    func getAverages() -> Dictionary <String, Double> {
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
    
}
