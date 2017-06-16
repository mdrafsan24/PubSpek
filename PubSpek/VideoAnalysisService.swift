//
//  VideoAnalysisService.swift
//  PubSpek
//
//  Created by Rafsan Chowdhury on 5/21/17.
//  Copyright © 2017 Mcraf. All rights reserved.
//

import Foundation
import Alamofire
import Firebase
import SwiftyJSON
class VideoAnalysisService {
    static let instance = VideoAnalysisService()
    static let apiKey = "c3947a8ef7524a3bb94206468ce48805" /// set in constants file
    static let apiUrl = "https://westus.api.cognitive.microsoft.com/emotion/v1.0/recognize"
    private var numReqs = 0

    func analyzeVideo(url : String) {
        var header = [String : String]()
        header["Ocp-Apim-Subscription-Key"] = VideoAnalysisService.apiKey
        
        let params:[String: String] = ["url": url]
        
        let request = Alamofire.request(VideoAnalysisService.apiUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header)
        
        numReqs += 1
        print(request)
        request.responseJSON { (response) in
            print(response)
            switch response.result {
            case .success(let data):
                // REQUEST OK! RESPONSE OK BUT FAILED TO DOWNLOAD
                print(data)
                let json = JSON(data)
                if (json[0]["scores"]["anger"].double != nil) {
                    VideoAnalysisData.instance.addScores(json: json)
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func doneAnalyzing() -> Bool {
        if (VideoAnalysisData.instance.numScores == numReqs) {
            return true
        }
        return false
    }
    
    
    
}
