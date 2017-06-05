//
//  ProgressBarView.swift
//  PubSpek
//
//  Created by Rafsan Chowdhury on 6/3/17.
//  Copyright © 2017 Mcraf. All rights reserved.
//

import UIKit
@IBDesignable
class ProgressBarView: UIView {
        
    override func draw(_ rect: CGRect) {
        ProgressBar.drawArtboard(frame: self.bounds, resizing: .aspectFit, progress: ProgressDetails.instance.progress)
    }

}
