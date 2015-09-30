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
    var counterVC: CounterViewController!
    var matchesVC: MatchesViewController!
    var profileVC: ProfileViewController!
    var settingsVC: SettingsViewController!

    // index defaulted to home
    var selectedIndex: Int! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("frame 123456789234567 \(mainContainerVC.frame)")
        // view controller instantiation
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        counterVC = storyboard.instantiateViewControllerWithIdentifier("counterSBID") as! CounterViewController
        matchesVC = storyboard.instantiateViewControllerWithIdentifier("matchesSBID") as! MatchesViewController
        profileVC = storyboard.instantiateViewControllerWithIdentifier("profileSBID") as! ProfileViewController
        settingsVC = storyboard.instantiateViewControllerWithIdentifier("settingsSBID") as! SettingsViewController
        
        // add the instantiated views into the array
        viewControllerArray = [counterVC, matchesVC, profileVC, settingsVC]
        
        // default to homepage
        displayContentViewController(mainContainerVC, content: counterVC)
        tabControllerButtonCollection[0].selected = true
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}