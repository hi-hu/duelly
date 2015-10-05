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
        
        // rounding corners
        counterViewController.layer.cornerRadius = 4.0
        counterViewController.clipsToBounds = true
        
        // rotating topViewController
        topViewController.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))

        // adding gradient
        createGradient(topViewController, color1: gradientColors["asphalt-500"]!, color2: gradientColors["green-500"]!)
        createGradient(bottomViewController, color1: gradientColors["asphalt-500"]!, color2: gradientColors["asphalt-700"]!)
    }

    override func viewWillAppear(animated: Bool) {
        // fetch the new event here!
    }
    
    override func viewDidLayoutSubviews() {
        print("did layout subviews")
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
    
    func createGradient(viewToRound: UIView, color1: UIColor, color2: UIColor) {
        let gradient: CAGradientLayer = CAGradientLayer()

        // creating the gradient color
        gradient.frame = viewToRound.bounds
        gradient.colors = [color1.CGColor, color2.CGColor]

        // setting the gradient color and mask shape
        viewToRound.layer.insertSublayer(gradient, atIndex: 0)
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
