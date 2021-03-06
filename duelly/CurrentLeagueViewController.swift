//
//  CurrentLeagueViewController.swift
//  duelly
//
//  Created by Mike Hu on 6/16/16.
//  Copyright © 2016 hi_hu. All rights reserved.
//

import UIKit

class CurrentLeagueViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UIAlertViewDelegate {
/*
 Next Steps:
 1) DONE - Unwinding from CurrentLeagueVC
     
 2) DONE - Persistance of player and league
     [x] Once a player and league are set, saving them to disk
     [x] Look into NSUserDefaults.
     [x] Convert object to dictionary (via ObjectMapper), then save that to defaults as two seperate keys
     [x] Upon startup check if dictionary exists at key, try to serialize into the object via object mapper, and then set in LeagueManager.sharedInstance
     [x] Turn player into JSON object
     [x] save JSON object into NSUserDefaults as a key value
     [x] later, if the player (or league) is set, take the key value from NSUserDefaults, and convert that back into a Player or League object via ObjectMapper.
     [x] if let chain
     [x] do it in the initialization
     [x] put names and variables in a global constant to reference
     
 3) Matches
     [ ] Think about how app should create matches
     [ ] Use LeagueManager methods to create matches
     [ ] Match making
     [ ] Updating matches after completed games
 4) League weeks
     [ ] Add week to matches struct and league struct
     [ ] Delete old matches and leagues from firebase
     [ ] Matchmaking
     [ ] CollectionView population and selection
 5) Match Cells
     [ ] Use matches for a given week to populate cells
     [ ] Button to start entering results for a match on a cell
     [ ] Popover View to specify what the result was
     [ ] API Call to update match on server
     [ ] Refresh table view
 */

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
        
        populateWithLeagueAndPlayer(LeagueManager.sharedInstance.league!, player: LeagueManager.sharedInstance.player!)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let userID = userDefaults.stringForKey("playerJSON") {
            print("player JSON is \(userID)")
        }
    }
    
    func populateWithLeagueAndPlayer(league:League, player:Player) {
        LeagueManager.sharedInstance.getMatchesForLeague(league) { matches in
            matches
            let playerMatches = matches.matchesForPlayerName(player.name)
            let record = playerMatches.recordForName(player.name)
            
            self.winsLabel.text = "\(record.wins)"
            self.lossesLabel.text = "\(record.losses)"
            self.tiesLabel.text = "\(record.draws)"
            self.byesLabel.text = "\(record.byes)"
            
            let score = league.rubric.scoreForRecord(record)
            let rankedNames = matches.leagueRankByName(league.rubric)
            
            if let index = rankedNames.indexOf(player.name) {
                self.standingLabel.text = "\(index)\(index.ordinalSuffix()) / \(score) pts"
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
        self.performSegueWithIdentifier("unwindToCounter", sender: self)
    }

    @IBAction func addPlayerDidPress(sender: AnyObject) {
        // Ignore depreciation or replace with UIAlertViewController
        let alert = UIAlertView(title: "Add Player", message: "What is the player's name?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Save")
        
        alert.alertViewStyle = .PlainTextInput
        alert.show()
    }
    
    // MARK: UIAlertView
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        guard let name = alertView.textFieldAtIndex(0)?.text
            where buttonIndex == 1 && name != "" else { return }
        
        let player = Player(name:name)
        let league = LeagueManager.sharedInstance.league!
        
        LeagueManager.sharedInstance.addPlayerToLeague(player, league: league) { _ in
            
            // TODO: Reload with updated matches
            
        }
    }
}