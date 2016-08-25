//
//  LoginViewController.swift
//  duelly
//
//  Created by Hi_Hu on 11/17/15.
//  Copyright © 2015 hi_hu. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var loginView: UIView!
//    @IBOutlet weak var loginTitle: UILabel!
    @IBOutlet weak var playButton: UIButton!

    var loginTextCenterYConstraintConstantOrigin: CGFloat = 0
    
//    @IBOutlet weak var loginTitleBottomConstraint: NSLayoutConstraint!
    var loginTitleBottomConstraintConstantOrigin: CGFloat = 16

    @IBOutlet weak var playButtonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var playButtonTrailingConstraint: NSLayoutConstraint!
    
    var loginTransition: LoginTransition!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set background gradient
//        let backgroundGradientLayer = Colors.createGradientLayer(loginView.bounds, color1: Colors.green500, color2: Colors.asphalt500)
//        loginView.layer.insertSublayer(backgroundGradientLayer, atIndex: 0)
        
        
//        loginTitle.attributedText = NSMutableAttributedString(string: "DUELLY", attributes: [NSKernAttributeName: letterSpacing] )
        
        playButton.layer.cornerRadius = cornerRadius

        // set defaults for animation
//        loginTitleBottomConstraintConstantOrigin = loginTitleBottomConstraint.constant
//        loginTitleBottomConstraint.constant = 200
//        loginTitle.alpha = 0
        
        playButtonLeadingConstraint.constant = 200
        playButtonTrailingConstraint.constant = 200
        playButton.alpha = 0
        
        
        // 
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 4, initialSpringVelocity: 1, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            // animate the views
//            self.loginTitleBottomConstraint.constant = self.loginTitleBottomConstraintConstantOrigin
//            self.loginTitle.alpha = 1
            
            self.playButtonLeadingConstraint.constant = 20
            self.playButtonTrailingConstraint.constant = 20
            self.playButton.alpha = 1
            
            self.view.layoutIfNeeded()
            }) { (Bool) -> Void in
                // code
        }
    }
    
    @IBAction func loginDidPress(sender: AnyObject) {
        self.performSegueWithIdentifier("loginSegue", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationVC = segue.destinationViewController as! MainContainerViewController
        loginTransition = LoginTransition()
        destinationVC.transitioningDelegate = loginTransition
    }
}
