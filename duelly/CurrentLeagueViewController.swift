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
        
        populateWithLeagueAndPlayer(LeagueManager.sharedInstance.league!, player: LeagueManager.sharedInstance.player!)
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
        // TODO: Look into unwinding view controllers
        dismissViewControllerAnimated(true, completion: nil)
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