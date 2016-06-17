//
//  MainContainerViewController.swift
//  duelly
//
//  Created by Hi_Hu on 9/28/15.
//  Copyright © 2015 hi_hu. All rights reserved.
//

import UIKit

class MainContainerViewController: UIViewController {

    @IBOutlet weak var mainContainerView: UIView!
    
    // array of tab controller buttons
    @IBOutlet var tabControllerButtonCollection: [UIButton]!
    
    // array holding the views
    var viewControllerArray = [UIViewController]()
    var counterVC: CounterViewController!
    var leagueVC: CurrentLeagueViewController!
    var profileVC: ProfileViewController!
    var settingsVC: SettingsViewController!

    // index defaulted to home
    var selectedIndex: Int! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set background gradient
//        let backgroundGradientLayer = Colors.createGradientLayer(mainContainerView.bounds, color1: Colors.yellow500, color2: Colors.yellow700)
//        mainContainerView.layer.insertSublayer(backgroundGradientLayer, atIndex: 0)
        
        // view controller instantiation
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        counterVC = storyboard.instantiateViewControllerWithIdentifier("counterSBID") as! CounterViewController
        leagueVC = storyboard.instantiateViewControllerWithIdentifier("currentLeagueSBID") as! CurrentLeagueViewController
        profileVC = storyboard.instantiateViewControllerWithIdentifier("profileSBID") as! ProfileViewController
        settingsVC = storyboard.instantiateViewControllerWithIdentifier("settingsSBID") as! SettingsViewController
        
        // add the instantiated views into the array
        viewControllerArray = [counterVC, leagueVC, profileVC, settingsVC]

        // also display counter view
        displayContentViewController(mainContainerView, content: counterVC)
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
        hideContentViewController(mainContainerView, content: viewControllerArray[currentIndex])
        
        // activate button add new selected view
        tabControllerButtonCollection[selectedIndex].selected = true
        displayContentViewController(mainContainerView, content: viewControllerArray[selectedIndex])
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
