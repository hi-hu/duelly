//
//  CounterViewController.swift
//  duelly
//
//  Created by Hi_Hu on 9/28/15.
//  Copyright © 2015 hi_hu. All rights reserved.
//

import UIKit

class CounterViewController: UIViewController {
    

    @IBOutlet weak var counterViewController: UIView!
    @IBOutlet weak var topViewController: UIView!
    @IBOutlet weak var topCounterLabel: UILabel!
    @IBOutlet weak var bottomViewController: UIView!
    @IBOutlet weak var bottomCounterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topViewController.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        
        counterViewController.layer.cornerRadius = 4.0
        counterViewController.clipsToBounds = true
    }

    override func viewWillAppear(animated: Bool) {
        // fetch the new event here!
    }
    
    override func viewDidLayoutSubviews() {
        print("did layout subviews")
        print(topViewController.frame)
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
        let gradient: CAGradientLayer = CAGradientLayer()

        // creating the masking shape
        rectShape.bounds = viewToRound.frame
        rectShape.position = viewToRound.center
        rectShape.path = UIBezierPath(roundedRect: viewToRound.bounds, byRoundingCorners: [UIRectCorner.BottomLeft, UIRectCorner.BottomRight], cornerRadii: radiusSize).CGPath

        // creating the gradient color
//        gradient.frame = viewToRound.bounds
//        gradient.position.x = viewToRound.center.x
//        gradient.position.y = viewToRound.center.y
//        gradient.colors = [UIColor.whiteColor().CGColor, UIColor.blackColor().CGColor]

        // setting the gradient color and mask shape
//        viewToRound.layer.backgroundColor = UIColor.greenColor().CGColor
//        viewToRound.layer.insertSublayer(gradient, atIndex: 0)
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
