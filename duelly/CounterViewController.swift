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

    // references to circle CAShapes to redraw purposes
    let topShapeLayer = CAShapeLayer()
    let bottomShapeLayer = CAShapeLayer()

    // NSTimer for incrementing counter
    var count = 0
    var timer = NSTimer()
    
    var stkColor: UIColor = duellyColors["green-200"]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // rounding corners
        counterViewController.layer.cornerRadius = 6.0
        counterViewController.clipsToBounds = true
        
        // rotating topViewController
        topViewController.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))

        // adding gradient
        createGradient(topViewController, color1: duellyColors["asphalt-500"]!, color2: duellyColors["green-500"]!)
        createGradient(bottomViewController, color1: duellyColors["asphalt-500"]!, color2: duellyColors["purple-700"]!)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.09, target: self, selector: Selector("update"), userInfo: nil, repeats: true)

        initLifeCounter()
    }

    override func viewWillAppear(animated: Bool) {
//        print("willAppear")
    }
    
    override func viewDidLayoutSubviews() {
        // seemingly gets called any time there's a draw event
        //        print("didLayoutSubviews")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func counterIncrement(sender: AnyObject) {
        var label = UILabel()
        var shape = CAShapeLayer()
        
        if(sender.superview == bottomViewController) {
            label = bottomCounterLabel
            shape = bottomShapeLayer
        } else {
            label = topCounterLabel
            shape = topShapeLayer
        }
        
        let numberFromString:Int! = Int(label.text!)
        label.text = String((numberFromString + 1))
    }
    
    @IBAction func counterDecrement(sender: AnyObject) {
        var label = UILabel()
        var shape = CAShapeLayer()

        if(sender.superview == bottomViewController) {
            label = bottomCounterLabel
            shape = bottomShapeLayer
        } else {
            label = topCounterLabel
            shape = topShapeLayer
        }
        
        let numberFromString:Int! = Int(label.text!)
        label.text = String((numberFromString - 1))

        if(numberFromString < 19) {
            
            let animateColorStart = CABasicAnimation(keyPath: "strokeColor")
            animateColorStart.fromValue = duellyColors["green-200"]!.CGColor
            animateColorStart.toValue = duellyColors["pink-500"]!.CGColor
            animateColorStart.duration = 1.5
            animateColorStart.beginTime = 0
            
            let animateColorEnd = CABasicAnimation(keyPath: "strokeColor")
            animateColorEnd.fromValue = duellyColors["pink-500"]!.CGColor
            animateColorEnd.toValue = duellyColors["green-200"]!.CGColor
            animateColorEnd.duration = 1.5
            animateColorEnd.beginTime = 1.5
            
            let animateGroup = CAAnimationGroup()
            animateGroup.duration = 3.0
            animateGroup.repeatCount = Float.infinity
            animateGroup.animations = [animateColorStart, animateColorEnd]
            
            shape.addAnimation(animateGroup, forKey: "allAnimations")
        }
    }

    @IBAction func resetDidPress(sender: AnyObject) {
        // reset life counter with NSTimer
        timer = NSTimer.scheduledTimerWithTimeInterval(0.09, target: self, selector: Selector("update"), userInfo: nil, repeats: true)

        // first quickly undraw the stroke then draw it back it
        drawStroke(topShapeLayer, startValue: 1, toValue: 1, duration: 0.6)
        drawStroke(bottomShapeLayer, startValue: 1, toValue: 1, duration: 0.6)
        delay(0.7) { () -> () in
            self.drawStroke(self.topShapeLayer, startValue: 1, toValue: 0, duration: 1)
            self.drawStroke(self.bottomShapeLayer, startValue: 1, toValue: 0, duration: 1)
        }
    }
    
    func drawStroke(layer: CAShapeLayer, startValue: CGFloat, toValue: CGFloat, duration: Double) {
        let animateStroke = CABasicAnimation(keyPath: "strokeStart")
        layer.strokeStart = startValue
        animateStroke.toValue = toValue
        animateStroke.duration = duration
        animateStroke.fillMode = kCAFillModeForwards
        animateStroke.removedOnCompletion = false
        animateStroke.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        layer.addAnimation(animateStroke, forKey: nil)
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
        var counter = 0
        var rectShape = CAShapeLayer()

        for donutView in donutViewCollection {
            if(counter == 0) {
                rectShape = bottomShapeLayer
            } else {
                rectShape = topShapeLayer
            }

            // setup the CAShapes
            let circleRadius = donutView.frame.width / 2
            let bounds = CGRect(x: 0, y: 0, width: circleRadius * 2, height: circleRadius * 2)
            let circleShape = UIBezierPath(roundedRect: bounds, cornerRadius: circleRadius).CGPath

            // draw stroke within bounds
            rectShape.bounds = bounds
            rectShape.position = CGPoint(x: donutView.frame.width / 2, y: donutView.frame.height / 2)
            rectShape.strokeColor = duellyColors["green-200"]!.CGColor
            rectShape.lineWidth = 2
            rectShape.fillColor = nil
            
            // rasterize to avoid pixelation
            donutView.layer.rasterizationScale = 4
            donutView.layer.shouldRasterize = true
            
            // add to view and set path
            donutView.layer.addSublayer(rectShape)
            rectShape.path = circleShape
            
            // animation properties
            drawStroke(rectShape, startValue: 1, toValue: 0, duration: 2)

            counter++
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
