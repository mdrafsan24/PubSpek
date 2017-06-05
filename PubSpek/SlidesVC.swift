//
//  SlidesVC.swift
//  PubSpek
//
//  Created by Rafsan Chowdhury on 6/4/17.
//  Copyright © 2017 Mcraf. All rights reserved.
//

import UIKit

class SlidesVC: UIViewController {
    var imgnum = 2
    @IBOutlet weak var slidesImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func nextBtnPressed(_ sender: UIButton) {
        if (imgnum > 3 ) {
            performSegue(withIdentifier: "goToUpload", sender: self)
        }
        slidesImg.image = UIImage(named: "Card\(imgnum)")
        imgnum = imgnum+1
    }

    @IBAction func swipedLeft(_ sender: UISwipeGestureRecognizer) {
        if (imgnum > 3 ) {
            performSegue(withIdentifier: "goToUpload", sender: self)
        }
        switch(sender.direction) {
        case UISwipeGestureRecognizerDirection.right:
            slidesImg.image = UIImage(named: "Card\(imgnum)")
            imgnum = imgnum+1
        default:
            break
        }
    }
    

}
