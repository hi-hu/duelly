//
//  LeagueSelectViewController.swift
//  duelly
//
//  Created by Andrew Schreiber on 6/27/16.
//  Copyright © 2016 hi_hu. All rights reserved.
//

import UIKit
import ObjectMapper

class LeagueSelectViewController: UIViewController, UITableViewDataSource, UIAlertViewDelegate, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    private let cellReuse = "cell"
    
    var leagues:[League] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LeagueManager.sharedInstance.getLeagues { leagues in
            self.leagues = leagues
        }
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellReuse)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuse, forIndexPath: indexPath)
        cell.textLabel?.text = leagues[indexPath.row].name
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leagues.count
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let league = leagues[indexPath.row]
        segueToLeague(league)
    }
    
    // MARK: Button Presses

    @IBAction func backDidPress(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func createLeagueDidPress(sender: AnyObject) {
        let alert = UIAlertView(title: "Create League", message: "Give a name to the league", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Save")
        
        alert.alertViewStyle = .PlainTextInput
        alert.show()
    }
    
    // MARK: UIAlertView
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        guard let name = alertView.textFieldAtIndex(0)?.text
            where buttonIndex == 1 && name != "" else { return }
        
        let league = League(name: name, description: "", password: "")
        LeagueManager.sharedInstance.createLeague(league) { success in
            if success {
                self.segueToLeague(league)
            }
        }
    }
    
    func segueToLeague(league:League) {
        LeagueManager.sharedInstance.league = league

        // conver a league object into a JSON string then store in NSUserDefaults
        if let leagueJSONString = Mapper().toJSONString(league, prettyPrint: true) {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setObject(leagueJSONString, forKey: "leagueJSON")
        }
        
        performSegueWithIdentifier("toSelectPlayer", sender: self)
    }
    
}