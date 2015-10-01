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
        
        topViewController.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func counterIncrement(sender: AnyObject) {
        if( sender.superview == bottomViewController ) {
            let numberFromString:Int! = Int(bottomCounterLabel.text!)
            bottomCounterLabel.text = String((numberFromString + 1))
        } else {
            let numberFromString:Int! = Int(topCounterLabel.text!)
            topCounterLabel.text = String((numberFromString + 1))
        }
    }
    
    @IBAction func counterDecrement(sender: AnyObject) {
        if( sender.superview == bottomViewController ) {
            let numberFromString:Int! = Int(bottomCounterLabel.text!)
            bottomCounterLabel.text = String((numberFromString - 1))
        } else {
            let numberFromString:Int! = Int(topCounterLabel.text!)
            topCounterLabel.text = String((numberFromString - 1))
        }
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
