//
//  PlayerSelectViewController.swift
//  duelly
//
//  Created by Andrew Schreiber on 6/27/16.
//  Copyright © 2016 hi_hu. All rights reserved.
//

import UIKit
import ObjectMapper

class PlayerSelectViewController: UIViewController, UITableViewDataSource, UIAlertViewDelegate, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var players:[Player] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let league = LeagueManager.sharedInstance.league {
            
            LeagueManager.sharedInstance.getPlayersForLeague(league) { (players) in
                self.players = players
            }
            
        } else {
            fatalError("Didn't get a league!!")
        }
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = players[indexPath.row].name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let player = players[indexPath.row]
        segueToPlayer(player)
    }
    
    
    @IBAction func backDidPress(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func createDidPress(sender: AnyObject) {
        
        let alert = UIAlertView(title: "New Player", message: "What is your name?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Save")
        
        alert.alertViewStyle = .PlainTextInput
        alert.show()
    }
    
    // MARK: UIAlertView
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        guard let name = alertView.textFieldAtIndex(0)?.text
            where buttonIndex == 1 && name != "" else { return }
        let player = Player(name:name)
        segueToPlayer(player)
    }
    
    func segueToPlayer(player:Player) {
        LeagueManager.sharedInstance.player = player
        
        if let playerJSONString = Mapper().toJSONString(player, prettyPrint: true) {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setObject(playerJSONString, forKey: "playerJSON")
        }

        performSegueWithIdentifier("toLeagueView", sender: self)
    }
}
