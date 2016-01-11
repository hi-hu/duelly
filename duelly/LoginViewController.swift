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
    var loginTitleBottomConstraintConstantOrigin: CGFloat = 0

    @IBOutlet weak var fbButtonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var fbButtonTrailingConstraint: NSLayoutConstraint!
    
    var fadeTransition: FadeTransition!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // this only works if the use is logged in 
//        currentUser = PFUser.currentUser()!
//        print(currentUser)
        
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
            
            self.loginTitleBottomConstraint.constant = self.loginTextCenterYConstraintConstantOrigin
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
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, block: {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    print("User signed up and logged in through Facebook!")
                } else {
                    print("User logged in through Facebook!")
                    self.performSegueWithIdentifier("loginSegue", sender: nil)
                }
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        })
    }

    
    
    
    
    
    
//    @IBAction func logoutDidPress(sender: AnyObject) {
//        PFUser.logOut()
//        PFFacebookUtils.unlinkUserInBackground(currentUser)
//        print("loggin out")
//
//    }
    
func getUserInfo() {
//    if let session = PFSession() {
//        if session.isOpen {
//            print("session is open")
//            FBRequestConnection.startForMeWithCompletionHandler({ (connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
//                //println("done me request") 
//                if error != nil {
//                    println("facebook me request - error is not nil :(")
//                } else {
//                    println("facebook me request - error is nil :) ")
//                    let urlUserImg = "http://graph.facebook.com/\(result.objectID)/picture?type=large"
//                    let firstName = result.first_name
//                    let lastName = result.last_name
//                }
//            })
//        }
//    } else {
//        //let user:PFUser = PFUser.currentUser() 
//        //println("ohooo \(user)")     
//    }
}
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print("prep for segue")
        
        let destinationVC = segue.destinationViewController
        
        fadeTransition = FadeTransition()
        
        destinationVC.transitioningDelegate = fadeTransition
    }


}
