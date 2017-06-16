//
//  RandomID.swift
//  PubSpek
//
//  Created by Rafsan Chowdhury on 6/5/17.
//  Copyright © 2017 Mcraf. All rights reserved.
//

import Foundation

class RandomID {
    
    static let instance = RandomID()
    
    // TO Generate Random ID for each user
    private var _userId = ""
    
    var userId: String {
        get {
            return self._userId
        }
    }
    // Creates a new ID 
    func createId(){
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< 4 {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        self._userId = randomString
    }
    
}
