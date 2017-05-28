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

class SpeechToTextService {
    
    private var transcribedText = [String]()
    private var fullText = String()
    
    static let instance = SpeechToTextService()
    /*----------------------------------------------------------------------------------------*/
    static let transcribeAPIKey = "a7c0c805ee1d43efbe086fd322dc9b3a" //COMPUTER VISION API
    static let transcribeAPIURL = "https://api.cognitive.microsoft.com/sts/v1.0"
    /*----------------------------------------------------------------------------------------*/
    var getTranscribedText: String {
        // This returns the fully transcribed text
        get {
            return self.fullText
        }
    }
    /*----------------------------------------------------------------------------------------*/
    func transcribeSpeech(url : String) {
        fullText = String()
        var header = [String : String]()
        header["Ocp-Apim-Subscription-Key"] = SpeechToTextService.transcribeAPIKey
        
        let params:[String: String] = ["url": url]
        
        let request = Alamofire.request(TranscribeService.transcribeAPIURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header)
        
        print("\(request)")
        
        request.responseJSON { (response) in
            
           print(response)
        
        }
        
    }
    
}
