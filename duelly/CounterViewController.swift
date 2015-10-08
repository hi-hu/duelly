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
    @IBOutlet weak var counterMenuStackController: UIStackView!
    @IBOutlet weak var topViewController: UIView!
    @IBOutlet weak var topCounterView: UIView!
    @IBOutlet weak var topCounterLabel: UILabel!
    @IBOutlet weak var bottomViewController: UIView!
    @IBOutlet weak var bottomCounterView: UIView!
    @IBOutlet weak var bottomCounterLabel: UILabel!
    @IBOutlet var counterMenuButtonCollection: [UIButton]!
    @IBOutlet weak var dView: UIView!
    @IBOutlet var donutViewCollection: [UIView]!

    
    var count = 0
    
    var timer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // rounding corners
        counterViewController.layer.cornerRadius = 6.0
        counterViewController.clipsToBounds = true
        
        // rotating topViewController
        topViewController.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))

        // adding gradient
        createGradient(topViewController, color1: gradientColors["asphalt-500"]!, color2: gradientColors["green-500"]!)
        createGradient(bottomViewController, color1: gradientColors["asphalt-500"]!, color2: gradientColors["purple-700"]!)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.09, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
    }

    override func viewWillAppear(animated: Bool) {
        print("willAppear")
    }
    
    override func viewDidLayoutSubviews() {
        print("didLayoutSubviews")
        initLifeCounter()

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

        // setting the gradient color
        viewToRound.layer.insertSublayer(gradient, atIndex: 0)
    }

    func initLifeCounter() {
        for donutView in donutViewCollection {
            // setup the CAShapes
            let circleRadius = donutView.frame.width / 2
            let bounds = CGRect(x: 0, y: 0, width: circleRadius * 2, height: circleRadius * 2)
            let rectShape = CAShapeLayer()
            let circleShape = UIBezierPath(roundedRect: bounds, cornerRadius: circleRadius).CGPath

            // draw stroke within bounds
            rectShape.bounds = bounds
            rectShape.position = CGPoint(x: donutView.frame.width / 2, y: donutView.frame.height / 2)
            rectShape.strokeColor = UIColor.whiteColor().CGColor
            rectShape.lineWidth = 2
            rectShape.fillColor = UIColor.clearColor().CGColor
            
            // rasterize to avoid pixelation
            donutView.layer.rasterizationScale = 4
            donutView.layer.shouldRasterize = true
            
            // add to view and set path
            donutView.layer.addSublayer(rectShape)
            rectShape.path = circleShape
            
            // animation properties
            let animateStroke = CABasicAnimation(keyPath: "strokeStart")
            rectShape.strokeStart = 1
            animateStroke.toValue = 0
            animateStroke.duration = 2.0
            animateStroke.fillMode = kCAFillModeForwards
            animateStroke.removedOnCompletion = false
            animateStroke.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            rectShape.addAnimation(animateStroke, forKey: nil)
        }
    }
    
    func update() {
        if(count < 21) {
            topCounterLabel.text = String(count)
            bottomCounterLabel.text = String(count++)
        } else {
            timer.invalidate()
            count = 0
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
