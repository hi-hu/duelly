//
//  MainContainerViewController.swift
//  duelly
//
//  Created by Hi_Hu on 9/28/15.
//  Copyright © 2015 hi_hu. All rights reserved.
//

import UIKit

class MainContainerViewController: UIViewController {

    @IBOutlet weak var mainContainerVC: UIView!
    
    // array of tab controller buttons
    @IBOutlet var tabControllerButtonCollection: [UIButton]!
    
    // array holding the views
    var viewControllerArray = [UIViewController]()
    var loginVC: LoginViewController!
    var counterVC: CounterViewController!
    var matchesVC: MatchesViewController!
    var profileVC: ProfileViewController!
    var settingsVC: SettingsViewController!

    // index defaulted to home
    var selectedIndex: Int! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainContainerVC.backgroundColor = duellyColors["asphalt-700"]
        
        // view controller instantiation
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        counterVC = storyboard.instantiateViewControllerWithIdentifier("counterSBID") as! CounterViewController
        matchesVC = storyboard.instantiateViewControllerWithIdentifier("matchesSBID") as! MatchesViewController
        profileVC = storyboard.instantiateViewControllerWithIdentifier("profileSBID") as! ProfileViewController
        settingsVC = storyboard.instantiateViewControllerWithIdentifier("settingsSBID") as! SettingsViewController
        loginVC = storyboard.instantiateViewControllerWithIdentifier("loginSBID") as! LoginViewController
        
        // add the instantiated views into the array
        viewControllerArray = [counterVC, matchesVC, profileVC, settingsVC]
        
        // default to login
        displayContentViewController(view, content: loginVC)
//        displayContentViewController(mainContainerVC, content: counterVC)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tabButtonDidPress(sender: AnyObject) {
        let currentIndex = selectedIndex
        selectedIndex = sender.tag
        
        // deactivate button  and remove current view
        tabControllerButtonCollection[currentIndex].selected = false
        hideContentViewController(mainContainerVC, content: viewControllerArray[currentIndex])
        
        // activate button add new selected view
        tabControllerButtonCollection[selectedIndex].selected = true
        displayContentViewController(mainContainerVC, content: viewControllerArray[selectedIndex])
    }
    
    // add a subbview to the specified container
    func displayContentViewController(container: UIView, content: UIViewController) {
        content.view.frame = container.frame
        addChildViewController(content)
        container.addSubview(content.view)
        content.didMoveToParentViewController(self)
    }

    // remove a subview from the specified container
    func hideContentViewController(container: UIView, content: UIViewController) {
        content.willMoveToParentViewController(nil)
        content.view.removeFromSuperview()
        content.removeFromParentViewController()
    }

    override func shouldAutorotate() -> Bool {
        if (UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeLeft ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeRight ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.Unknown) {
                return false
        }
        else {
            return true
        }
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.Portrait]
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
