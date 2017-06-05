//
//  ProgressDetails.swift
//  PubSpek
//
//  Created by Rafsan Chowdhury on 6/4/17.
//  Copyright © 2017 Mcraf. All rights reserved.
//

import Foundation

class ProgressDetails {
    
    static let instance = ProgressDetails()

    private var _progress = Int()
    
    var progress: Int {
        get {
            return self._progress
        }
        
        set (progress) {
            if (progress >= 20 &&  progress <= 100) {
                self._progress = progress
            } else {
                self._progress = 20
            }
        }
    }
    
    
}
