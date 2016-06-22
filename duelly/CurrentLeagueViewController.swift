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
    
    @IBAction func testButtonPress(sender: AnyObject) {
        LeagueManager.sharedInstance.getLeagues { leagues in
            if let firstLeague = leagues.first {
                let league = League(autoID: firstLeague.autoID, name: "Replacement name", description: firstLeague.description, password: firstLeague.password)
                LeagueManager.sharedInstance.replaceLeague(league) { bool in
                    print("Replaced league with success \(bool)")
                }
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
