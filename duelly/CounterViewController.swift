//
//  CounterViewController.swift
//  duelly
//
//  Created by Hi_Hu on 9/28/15.
//  Copyright © 2015 hi_hu. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass
import GameplayKit

class CounterViewController: UIViewController {
    @IBOutlet weak var counterView: UIView!
    @IBOutlet weak var counterMenuStackController: UIStackView!
    @IBOutlet var counterStackButtonCollection: [UIButton]!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topCounterView: UIView!
    @IBOutlet weak var topCounterLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomCounterView: UIView!
    @IBOutlet weak var bottomCounterLabel: UILabel!
    @IBOutlet var counterMenuButtonCollection: [UIButton]!
    @IBOutlet var donutViewCollection: [UIView]!
    @IBOutlet weak var tapView: UIView!

    // references to circle CAShapes to redraw purposes
    let topShapeLayer = CAShapeLayer()
    let bottomShapeLayer = CAShapeLayer()

    // NSTimer for incrementing counter
    var count = 0
    var timer = NSTimer()

    // animation switch
    var topStrokeAnimationIsOff = true
    var bottomStrokeAnimationIsOff = true

    // six-sided dice
    let dice6 = GKRandomDistribution.d6()
    var diceTop = Dice()
    var diceBottom = Dice()
    var counterIsOn = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // prevent the app from going to sleep
        UIApplication.sharedApplication().idleTimerDisabled = true
        
        tapView.hidden = true

        // rounding corners
        counterView.layer.cornerRadius = 6.0
        counterView.clipsToBounds = true
        
        // rotating topView
        topView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        
        var counter = 0
        for donutView in donutViewCollection {
            if(counter == 0) {
                diceBottom.addToView(donutView)
                diceBottom.hidden(true)
            } else {
                diceTop.addToView(donutView)
                diceTop.hidden(true)
            }
            counter++
        }
        
        // animate counterView then animate the rest
        counterView.alpha = 0

        UIView.animateWithDuration(1.5, animations: { () -> Void in
            self.counterView.alpha = 1
            }) { (Bool) -> Void in
                // code
        }

        // adding gradient        
        let bgGradientLayer = Colors.createGradientLayer(counterView.bounds, color1: Colors.asphalt500, color2: Colors.purple700)
        counterView.layer.insertSublayer(bgGradientLayer, atIndex: 0)

        // animate all the buttons in view
        var count: NSTimeInterval = 0
        for btn in counterStackButtonCollection {
            btn.transform = CGAffineTransformMakeScale(0.3, 0.3)
            UIView.animateWithDuration(1, delay: (count / 8), usingSpringWithDamping: 0.3, initialSpringVelocity: 0.3, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                btn.transform = CGAffineTransformMakeScale(1, 1)
                btn.alpha = 1
                }, completion: { (Bool) -> Void in
            })
            count++
        }
        
        // time event to draw the circles on load
        timer = NSTimer.scheduledTimerWithTimeInterval(0.09, target: self, selector: Selector("resetLabel"), userInfo: nil, repeats: true)

        initLifeCounter()
    }

    override func viewWillAppear(animated: Bool) {
        // print("willAppear")
    }
    
    override func viewDidLayoutSubviews() {
        // seemingly gets called any time there's a draw event
        // print("didLayoutSubviews")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func counterIncrement(sender: AnyObject) {
        viewToggles(false, diceView: true)

            var label = UILabel()
            var shape = CAShapeLayer()
        
            if(sender.superview == bottomView) {
                label = bottomCounterLabel
                shape = bottomShapeLayer
            } else {
                label = topCounterLabel
                shape = topShapeLayer
            }
        
            let numberFromString:Int! = Int(label.text!)
            label.text = String((numberFromString + 1))
        
            if(numberFromString >= 5) {
                shape.removeAnimationForKey("warningAnimations")
            }
    }
    
    @IBAction func counterDecrement(sender: AnyObject) {
        viewToggles(false, diceView: true)

        var label = UILabel()
        var shape = CAShapeLayer()

        if(sender.superview == bottomView) {
            label = bottomCounterLabel
            shape = bottomShapeLayer
        } else {
            label = topCounterLabel
            shape = topShapeLayer
        }
        
        let numberFromString:Int! = Int(label.text!)
        label.text = String((numberFromString - 1))

        if(numberFromString < 7) {
            let animateColorStart = CABasicAnimation(keyPath: "strokeColor")
            animateColorStart.fromValue = Colors.green200.CGColor
            animateColorStart.toValue = Colors.pink500.CGColor
            animateColorStart.duration = 1.5
            animateColorStart.beginTime = 0
            
            let animateColorEnd = CABasicAnimation(keyPath: "strokeColor")
            animateColorEnd.fromValue = Colors.pink500.CGColor
            animateColorEnd.toValue = Colors.green200.CGColor
            animateColorEnd.duration = 1.5
            animateColorEnd.beginTime = 1.5

            let animateLineWidthStart = CABasicAnimation(keyPath: "lineWidth")
            animateLineWidthStart.fromValue = 2
            animateLineWidthStart.toValue = 6
            animateLineWidthStart.duration = 1.5
            animateLineWidthStart.beginTime = 0
            
            let animateLineWidthEnd = CABasicAnimation(keyPath: "lineWidth")
            animateLineWidthEnd.fromValue = 6
            animateLineWidthEnd.toValue = 2
            animateLineWidthEnd.duration = 1.5
            animateLineWidthEnd.beginTime = 1.5
            
            let animateGroup = CAAnimationGroup()
            animateGroup.duration = 3.0
            animateGroup.repeatCount = Float.infinity
            animateGroup.animations = [animateColorStart, animateColorEnd, animateLineWidthStart, animateLineWidthEnd]
            
            shape.addAnimation(animateGroup, forKey: "warningAnimations")
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
            rectShape.strokeColor = Colors.green200.CGColor
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

    func resetLabel() {
        if(count < 21) {
            topCounterLabel.text = String(count)
            bottomCounterLabel.text = String(count++)
        } else {
            timer.invalidate()
            count = 0
        }
    }
    
    @IBAction func rollDidPress(sender: AnyObject) {
        if counterIsOn {
            // hide counterView
            // and set counterIsOn to false
            counterIsOn = false
            viewToggles(true, diceView: false)
        } 
        
        var topDie = 1
        var bottomDie = 1
        
        // prevent ties
        while topDie == bottomDie {
            topDie = dice6.nextInt()
            bottomDie = dice6.nextInt()
        }
        
        diceBottom.rollDie(bottomDie)
        diceTop.rollDie(topDie)
    }

    @IBAction func resetDidPress(sender: AnyObject) {
        counterIsOn = true
        viewToggles(false, diceView: true)

        // reset life counter with NSTimer
        timer.invalidate()
        topShapeLayer.removeAnimationForKey("strokeStart")
        bottomShapeLayer.removeAnimationForKey("strokeStart")
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.09, target: self, selector: Selector("resetLabel"), userInfo: nil, repeats: true)

        topShapeLayer.removeAnimationForKey("warningAnimations")
        bottomShapeLayer.removeAnimationForKey("warningAnimations")
        
        // first quickly undraw the stroke then draw it back it
        drawStroke(topShapeLayer, startValue: 1, toValue: 1, duration: 0.6)
        drawStroke(bottomShapeLayer, startValue: 1, toValue: 1, duration: 0.6)
        delay(0.7) { () -> () in
            self.drawStroke(self.topShapeLayer, startValue: 1, toValue: 0, duration: 1)
            self.drawStroke(self.bottomShapeLayer, startValue: 1, toValue: 0, duration: 1)
        }
    }

    @IBAction func viewDidTap(sender: AnyObject) {
        viewToggles(false, diceView: true)
        counterIsOn = true
    }
    
    func viewToggles(counterView: Bool, diceView: Bool) {
        topCounterLabel.hidden = counterView
        bottomCounterLabel.hidden = counterView
        diceBottom.hidden(diceView)
        diceTop.hidden(diceView)
        tapView.hidden = diceView
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
