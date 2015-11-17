//
//  LoginViewController.swift
//  duelly
//
//  Created by Hi_Hu on 11/17/15.
//  Copyright © 2015 hi_hu. All rights reserved.
//

import UIKit
import ParseFacebookUtilsV4

var counterVC: UIViewController!
var mainContainerVC: UIView!

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print("login page")
        
        var currentUser = PFUser.currentUser()!
        
        print(currentUser)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginDidPress(sender: AnyObject) {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, block: {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    print("User signed up and logged in through Facebook!")
                } else {
                    print("User logged in through Facebook!")
                    
                    // if log in is success remove this view.
                    self.view.removeFromSuperview()
                    self.removeFromParentViewController()
                    
                    print("<———————————cokmplete")

                    print(counterVC)
                    print(mainContainerVC)
                    
                    // then trigger loading animation
//                    self.addChildViewController(counterVC)
                    mainContainerVC.addSubview(counterVC.view)
                    counterVC.didMoveToParentViewController(self)
                    
                    print("<———————————cokmplete 12345678")
                }
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        })
    }

    @IBAction func logoutDidPress(sender: AnyObject) {
        print("loggin out")
//        PFFacebookUtils.unlinkUserInBackground(PFUser)
    }
    
    func setViews(container: UIView, content: UIViewController) {
        counterVC = content
        mainContainerVC = container
    }
    
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
