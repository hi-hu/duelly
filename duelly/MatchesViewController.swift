//
//  MatchesViewController.swift
//  duelly
//
//  Created by Hi_Hu on 9/28/15.
//  Copyright © 2015 hi_hu. All rights reserved.
//

import UIKit

class MatchesViewController: UIViewController {
    
    @IBOutlet weak var thisView: UIView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let rectShape = CAShapeLayer()
        rectShape.bounds = self.thisView.frame
        rectShape.position = self.thisView.center
        rectShape.path = UIBezierPath(roundedRect: self.thisView.bounds, byRoundingCorners: [UIRectCorner.BottomLeft, UIRectCorner.BottomRight, UIRectCorner.TopLeft], cornerRadii: CGSize(width: 20, height: 20)).CGPath
        
        self.thisView.layer.backgroundColor = UIColor.greenColor().CGColor
        //Here I'm masking the textView's layer with rectShape layer
        self.thisView.layer.mask = rectShape
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
