//
//  LoginViewController.swift
//  duelly
//
//  Created by Hi_Hu on 11/17/15.
//  Copyright © 2015 hi_hu. All rights reserved.
//

import UIKit
import ParseFacebookUtilsV4

var currentUser = PFUser()


class LoginViewController: UIViewController {

    @IBOutlet var loginView: UIView!
    @IBOutlet weak var loginTitle: UILabel!
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var loginText: UILabel!

    @IBOutlet weak var loginTextCenterYConstraint: NSLayoutConstraint!
    var loginTextCenterYConstraintConstantOrigin: CGFloat = 0
    
    @IBOutlet weak var loginTitleBottomConstraint: NSLayoutConstraint!
    var loginTitleBottomConstraintConstantOrigin: CGFloat = 16

    @IBOutlet weak var fbButtonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var fbButtonTrailingConstraint: NSLayoutConstraint!
    
    var fadeTransition: FadeTransition!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createGradient(loginView, color1: asphalt500, color2: asphalt700)
        
        loginTitle.attributedText = NSMutableAttributedString(string: "DUELLY", attributes: [NSKernAttributeName: letterSpacing] )
        
        fbButton.layer.cornerRadius = cornerRadius

        // set defaults for animation
        loginTextCenterYConstraintConstantOrigin = loginTextCenterYConstraint.constant
        loginTextCenterYConstraint.constant = 400
        loginText.alpha = 0
        
        loginTitleBottomConstraintConstantOrigin = loginTitleBottomConstraint.constant
        loginTitleBottomConstraint.constant = 200
        loginTitle.alpha = 0
        
        fbButtonLeadingConstraint.constant = 200
        fbButtonTrailingConstraint.constant = 200
        fbButton.alpha = 0
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 4, initialSpringVelocity: 1, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            // code
            self.loginTextCenterYConstraint.constant = self.loginTextCenterYConstraintConstantOrigin
            self.loginText.alpha = 1
            
            self.loginTitleBottomConstraint.constant = self.loginTitleBottomConstraintConstantOrigin
            self.loginTitle.alpha = 1
            
            
            self.fbButtonLeadingConstraint.constant = 20
            self.fbButtonTrailingConstraint.constant = 20
            self.fbButton.alpha = 1
            
            self.view.layoutIfNeeded()
            }) { (Bool) -> Void in
                // code
        }
    }
    
    @IBAction func loginDidPress(sender: AnyObject) {
        self.performSegueWithIdentifier("loginSegue", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let destinationVC = segue.destinationViewController
        
        fadeTransition = FadeTransition()
        
        destinationVC.transitioningDelegate = fadeTransition
    }


}
