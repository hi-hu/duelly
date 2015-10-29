//
//  MatchesViewController.swift
//  duelly
//
//  Created by Hi_Hu on 9/28/15.
//  Copyright © 2015 hi_hu. All rights reserved.
//

import UIKit
import GameplayKit

class MatchesViewController: UIViewController {
    
    @IBOutlet weak var thisView: UIView!

    var dice = Dice()
    let dice6 = GKRandomDistribution.d6()
    
    override func viewDidLoad() {
        thisView.layer.cornerRadius = 90
        thisView.backgroundColor = UIColor.blackColor()
        
        super.viewDidLoad()

        dice.addToView(thisView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func rollDidPress(sender: AnyObject) {
        let randomNum = dice6.nextInt()
        dice.rollDie(randomNum)
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
