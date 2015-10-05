//
//  CounterViewController.swift
//  duelly
//
//  Created by Hi_Hu on 9/28/15.
//  Copyright © 2015 hi_hu. All rights reserved.
//

import UIKit

class CounterViewController: UIViewController {
    

    @IBOutlet weak var topViewController: UIView!
    @IBOutlet weak var topCounterLabel: UILabel!
    @IBOutlet weak var bottomViewController: UIView!
    @IBOutlet weak var bottomCounterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        topViewController.layer.cornerRadius = 8.0
        
        
//        let rectShape = CAShapeLayer()
//        rectShape.bounds = self.thisView.frame
//        rectShape.position = self.thisView.center
//        rectShape.path = UIBezierPath(roundedRect: self.thisView.bounds, byRoundingCorners: [UIRectCorner.BottomLeft, UIRectCorner.BottomRight, UIRectCorner.TopLeft], cornerRadii: CGSize(width: 20, height: 20)).CGPath
//        
//        self.thisView.layer.backgroundColor = UIColor.greenColor().CGColor
//        //Here I'm masking the textView's layer with rectShape layer
//        self.thisView.layer.mask = rectShape
        
        
        
        
        topViewController.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        
    }

    override func viewDidLayoutSubviews() {
        roundView(topViewController, radiusSize: CGSize(width: 4, height: 4))

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func counterIncrement(sender: AnyObject) {
        if(sender.superview == bottomViewController) {
            let numberFromString:Int! = Int(bottomCounterLabel.text!)
            bottomCounterLabel.text = String((numberFromString + 1))
        } else {
            let numberFromString:Int! = Int(topCounterLabel.text!)
            topCounterLabel.text = String((numberFromString + 1))
        }
    }
    
    @IBAction func counterDecrement(sender: AnyObject) {
        if(sender.superview == bottomViewController) {
            let numberFromString:Int! = Int(bottomCounterLabel.text!)
            bottomCounterLabel.text = String((numberFromString - 1))
        } else {
            let numberFromString:Int! = Int(topCounterLabel.text!)
            topCounterLabel.text = String((numberFromString - 1))
        }
    }

    @IBAction func resetDidPress(sender: AnyObject) {
        topCounterLabel.text = "20"
        bottomCounterLabel.text = "20"
    }
    
    func roundView(viewToRound: UIView, radiusSize: CGSize) {
        let rectShape = CAShapeLayer()
        
        rectShape.bounds = viewToRound.frame
        rectShape.position = viewToRound.center
        rectShape.path = UIBezierPath(roundedRect: viewToRound.bounds, byRoundingCorners: [UIRectCorner.BottomLeft, UIRectCorner.BottomRight], cornerRadii: radiusSize).CGPath
        
        viewToRound.layer.backgroundColor = UIColor.greenColor().CGColor
        viewToRound.layer.mask = rectShape
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
