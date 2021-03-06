//
//  LoginTransition.swift
//  duelly
//
//  Created by Mike Hu on 2/21/16.
//  Copyright © 2016 hi_hu. All rights reserved.
//

import UIKit

class LoginTransition: BaseTransition {

    override func presentTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {

        let loginVC = fromViewController as! LoginViewController
        loginVC.playButton.hidden = true
//        loginVC.loginTitle.hidden = true
        
        // create a shapeLayer from
        let shapeToAnimate = CAShapeLayer()

        // calculate the size of counterView
        let largeX = containerView.frame.origin.x + 18
        let largeY = containerView.frame.origin.y + 18
        let largeW = containerView.frame.width - 36
        let largeH = containerView.frame.height - 36
        let largeRect = UIBezierPath(roundedRect: CGRect(x: largeX, y: largeY, width: largeW, height: largeH), cornerRadius: cornerRadius).CGPath
        
        shapeToAnimate.path = UIBezierPath(roundedRect: loginVC.playButton.frame, cornerRadius: cornerRadius).CGPath
        shapeToAnimate.fillColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.14).CGColor
        containerView.layer.addSublayer(shapeToAnimate)

        let animateShape = CASpringAnimation(keyPath: "path")
        animateShape.damping = 20
        animateShape.stiffness = 0
        animateShape.initialVelocity = 5
        animateShape.toValue = largeRect
        animateShape.duration = 1.5
        animateShape.removedOnCompletion = false
        animateShape.fillMode = kCAFillModeForwards
        shapeToAnimate.addAnimation(animateShape, forKey: "pathAniamte")
        

//        shapeToAnimate.shadowColor = UIColor.blackColor().CGColor
//        shapeToAnimate.shadowOpacity = 0.4
//        shapeToAnimate.shadowOffset = CGSizeZero
//        shapeToAnimate.shadowRadius = 10
        
        
        // bump the text away
        toViewController.view.alpha = 0
        UIView.animateWithDuration(2, animations: {
            toViewController.view.alpha = 1
            
            // animate the shapeLayer to have the same constraints
            
            }) { (finished: Bool) -> Void in
                self.finish()
                shapeToAnimate.removeFromSuperlayer()
        }
    }
}