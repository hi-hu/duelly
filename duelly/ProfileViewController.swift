//
//  ProfileViewController.swift
//  duelly
//
//  Created by Hi_Hu on 9/28/15.
//  Copyright © 2015 hi_hu. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        // Create CAShapeLayer
        let rectShape = CAShapeLayer()
        rectShape.bounds = bounds
        rectShape.position = view.center
        view.layer.addSublayer(rectShape)
        
        rectShape.fillColor = UIColor.yellowColor().CGColor
        
        let startShape = UIBezierPath(roundedRect: bounds, cornerRadius: 50).CGPath
        
        rectShape.path = startShape
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
