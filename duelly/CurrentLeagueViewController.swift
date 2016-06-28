//
//  CurrentLeagueViewController.swift
//  duelly
//
//  Created by Mike Hu on 6/16/16.
//  Copyright © 2016 hi_hu. All rights reserved.
//

import UIKit

class CurrentLeagueViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource , UIAlertViewDelegate {

    @IBOutlet weak var matchesTableView: UITableView!
    @IBOutlet weak var weekCollectionView: UICollectionView!
    @IBOutlet weak var winsLabel: UILabel!
    @IBOutlet weak var lossesLabel: UILabel!
    @IBOutlet weak var tiesLabel: UILabel!
    @IBOutlet weak var byesLabel: UILabel!
    @IBOutlet weak var standingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        matchesTableView.dataSource = self
        weekCollectionView.dataSource = self
        
        // set collectionView layout behavior
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0)
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        layout.minimumInteritemSpacing = 12
        weekCollectionView.collectionViewLayout = layout
        weekCollectionView.showsHorizontalScrollIndicator = false
    }
    
    func populateWithLeagueAndPlayer(league:League, player:Player) {
        LeagueManager.sharedInstance.getMatchesForLeague(league) { matches in
            matches
            let myMatches = player.playerMatches(matches)
            let record = player.recordForMatches(myMatches)
            
            self.winsLabel.text = "\(record.wins)"
            self.lossesLabel.text = "\(record.losses)"
            self.tiesLabel.text = "\(record.draws)"
            self.byesLabel.text = "\(record.byes)"
            
            let score = league.rubric.scoreForRecord(record)
            let rankedNames = matches.leagueRankByName(league.rubric)
            
            if let index = rankedNames.indexOf(player.name) {
                self.standingLabel.text = "\(index)\(index.ordinalSuffix()) / \(score)"
            } else {
                self.standingLabel.text = "\(score)"
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var collectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath)
        
        return collectionCell
    }
        
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var tableCell = tableView.dequeueReusableCellWithIdentifier("MatchCell") as! MatchCell

        return tableCell
    }
    
    @IBAction func playDidPress(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func addPlayerDidPress(sender: AnyObject) {

        let alert = UIAlertView(title: "Add Player", message: "What is the player's name?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Save")
        
        alert.alertViewStyle = .PlainTextInput
        alert.show()
        
    }
    
    // MARK: UIAlertView
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        guard let name = alertView.textFieldAtIndex(0)?.text
            where buttonIndex == 1 && name != "" else { return }
        
        let player = Player(name:name, autoID: "")
        let league = LeagueManager.sharedInstance.league ?? League.testLeague()
        
        LeagueManager.sharedInstance.addPlayerToLeague(player, league: league) { _ in
            
            
            
            
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
