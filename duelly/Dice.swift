//
//  Dice.swift
//  duelly
//
//  Created by Hi_Hu on 10/28/15.
//  Copyright © 2015 hi_hu. All rights reserved.
//

import UIKit

class Dice {
    
    // representing the max 6 dots on a die
    var dotViewCollection = [UIView]()
    
    // Each side of the die with fixed positions for each dot. Position is relative to the parent.
    let dotCount_1: [[Int]] = [[ 78, 78, 1 ],[ 78, 78, 1 ],[ 78, 78, 1 ],[ 78, 78, 1 ],[ 78, 78, 1 ],[ 78, 78, 1 ]]
    let dotCount_2: [[Int]] = [[ 54, 54, 1 ],[ 102, 102, 1 ],[ 102, 102, 1 ],[ 102, 102, 1 ],[ 102, 102, 1 ],[ 102, 102, 1 ]]
    let dotCount_3: [[Int]] = [[ 78, 48, 1 ],[ 48, 102, 1 ],[ 108, 102, 1 ],[ 108, 102, 1 ],[ 108, 102, 1 ],[ 108, 102, 1 ]]
    let dotCount_4: [[Int]] = [[ 54, 102, 1 ],[ 54, 54, 1 ],[ 102, 54, 1 ],[ 102, 102, 1 ],[ 102, 102, 1 ],[ 102, 102, 1 ]]
    let dotCount_5: [[Int]] = [[ 78, 78, 1 ],[ 108, 48, 1 ],[ 48, 48, 1 ],[ 48, 108, 1 ],[ 108, 108, 1 ],[ 108, 108, 1 ]]
    let dotCount_6: [[Int]] = [[ 114, 102, 1 ],[ 114, 54, 1 ],[ 42, 102, 1 ],[ 42, 54, 1 ],[ 78, 54, 1 ],[ 78, 102, 1 ]]
    
    init() {
        // initalize and populate the view with 6 dots
        for var num = 0; num < 6; num++ {
            let dotView = UIView(frame: CGRectMake( CGFloat(dotCount_1[num][0]), CGFloat(dotCount_1[num][1]), 24, 24))
            dotView.alpha = CGFloat(dotCount_1[num][2])
            dotView.backgroundColor = UIColor.whiteColor()
            dotView.layer.cornerRadius = 12
            dotViewCollection.append(dotView)
        }
    }
    
    func addToView(view: UIView) {
        for dotView in dotViewCollection {
            view.addSubview(dotView)
        }
    }
    
    func rollDie(randomSide: Int) {
        var dotArray = [[Int]]()
        
        switch randomSide {
        case 1:
            dotArray = dotCount_1
        case 2:
            dotArray = dotCount_2
        case 3:
            dotArray = dotCount_3
        case 4:
            dotArray = dotCount_4
        case 5:
            dotArray = dotCount_5
        default:
            dotArray = dotCount_6
        }
        
        animateDots(dotArray)
    }
    
    func animateDots(dotArray: [[Int]]) {
        for var row = 0; row < 6; row++ {

            // set the point and alph of the dot from the randomly generated side
            let dotPoint = CGPoint(x: CGFloat(dotArray[row][0]), y: CGFloat(dotArray[row][1]))
            let dotAlpha = CGFloat(dotArray[row][2])
            let dotView: UIView = dotViewCollection[row]

            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 3, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                dotView.frame.origin = CGPoint(x: 78, y: 78)
                dotView.alpha = 1
                }, completion: { (Bool) -> Void in
            })
            delay(0.35, closure: { () -> () in
                UIView.animateWithDuration(1.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 3, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    dotView.frame.origin = dotPoint
                    dotView.alpha = dotAlpha
                    }, completion: { (Bool) -> Void in
                        // done
                })
            })
        }
    }
    
    func hidden(value: Bool) {
        for dot in dotViewCollection {
            dot.hidden = value
        }
    }
}