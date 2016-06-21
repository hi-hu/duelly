//
//  CurrentLeagueViewController.swift
//  duelly
//
//  Created by Mike Hu on 6/16/16.
//  Copyright © 2016 hi_hu. All rights reserved.
//

import UIKit

class CurrentLeagueViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func testPress(sender: AnyObject) {
        let league = League.testLeague()
        
        LeagueManager.sharedInstance.createLeague(league) { success in
            
            print("Created league with success: \(success)")
        }
        let player = Player(name: "Test Player")
        
        LeagueManager.sharedInstance.createPlayer(player) { success in
            print("Created player with success: \(success)")
        }
        
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
