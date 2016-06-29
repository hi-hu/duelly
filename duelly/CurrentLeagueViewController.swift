//
//  CurrentLeagueViewController.swift
//  duelly
//
//  Created by Mike Hu on 6/16/16.
//  Copyright © 2016 hi_hu. All rights reserved.
//

import UIKit

class CurrentLeagueViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
/*
 Next Steps:
 
 1) Unwinding from CurrentLeagueVC
 2) Persistance of player and league
    a) Once a player and league are set, saving them to disk
    b) Look into NSUserDefaults.
    c) Convert object to dictionary (via ObjectMapper), then save that to defaults as two seperate keys
    d) Upon startup check if dictionary exists at key, try to serialize into the object via object mapper, and then set in LeagueManager.sharedInstance
 3) Matches
    a) Think about how app should create matches
    b) Use LeagueManager methods to create matches
    c) Match making
    d) Updating matches after completed games
 4) League weeks
    a) Add week to matches struct and league struct
    b) Delete old matches and leagues from firebase
    c) Matchmaking
    d) CollectionView population and selection
 5) Match Cells
    a) Use matches for a given week to populate cells
    b) Button to start entering results for a match on a cell
    c) Popover View to specify what the result was
    d) API Call to update match on server
    e) Refresh table view
 */

    @IBOutlet weak var matchesTableView: UITableView!
    @IBOutlet weak var weekCollectionView: UICollectionView!
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
