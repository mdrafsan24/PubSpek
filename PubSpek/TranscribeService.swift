//
//  TranscribeService.swift
//  PubSpek
//
//  Created by Rafsan Chowdhury on 5/19/17.
//  Copyright © 2017 Mcraf. All rights reserved.
//

import Foundation
import Alamofire
import Firebase

class TranscribeService {
    
    private var transcribedText = [String]()
    private var fullText = String()
    
    static let instance = TranscribeService()
    /*----------------------------------------------------------------------------------------*/
    static let transcribeAPIKey = "b29bed3c94cb43c0a1b29f2ff07566c9" //COMPUTER VISION API
    static let transcribeAPIURL = "https://westus.api.cognitive.microsoft.com/vision/v1.0/ocr?language=en"
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
        header["Ocp-Apim-Subscription-Key"] = TranscribeService.transcribeAPIKey
        
        let params:[String: String] = ["url": url]
        
        let request = Alamofire.request(TranscribeService.transcribeAPIURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header)
        
        print("\(request)")
        
        request.responseJSON { (response) in
            if let response = response.value as? Dictionary<String, Any> {
                if let regions = response["regions"] as? [Dictionary<String, Any>] {
                    for region in regions {
                        if let lines = region["lines"] as? [Dictionary<String, Any>] {
                            for line in lines {
                                if let words = line["words"] as? [Dictionary<String, Any>] {
                                    for word in words {
                                        if let text = word["text"] as? String {
                                            self.transcribedText.append(text)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            for text in self.transcribedText {
                self.fullText += (text + " ")
                print(text, terminator: " ")
            }
        }

    }
    
    func transcribeDone() -> Bool {
        if self.fullText.characters.count > 20 {
            return true
        }
        return false
    }

}

