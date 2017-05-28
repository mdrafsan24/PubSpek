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
    static let apiKey = "0d4fd27854bf49669b3d238f1eba6786" /// set in constants file
    static let apiUrl = "https://westus.api.cognitive.microsoft.com/emotion/v1.0/recognize"
    private var happiness = Double()
    
    func analyzeVideo(url : String) {
        var header = [String : String]()
        header["Ocp-Apim-Subscription-Key"] = VideoAnalysisService.apiKey
        
        let params:[String: String] = ["url": url]
        
        let request = Alamofire.request(VideoAnalysisService.apiUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header)
        
        
        print("\(request)")
        
        request.responseJSON { (response) in
            //print(response)
            switch response.result {
            case .success(let data):
                print(data)
                let json = JSON(data)
                //self.happiness = json[0]["scores"]["happiness"].double! // DO If statement to make sure not nil
                
                
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func getHappiness() -> Double {
        return self.happiness
    }
}
