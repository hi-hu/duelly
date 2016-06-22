//
//  APIClient.swift
//  duelly
//
//  Created by Andrew Schreiber on 6/16/16.
//  Copyright © 2016 hi_hu. All rights reserved.
//

import Foundation
import Firebase

class APIClient {
    static let sharedClient = APIClient()
    
    let base:FIRDatabaseReference
    
    var leaguesRef:FIRDatabaseReference {
        return base.child("leagues")
    }
    var matchesRef:FIRDatabaseReference {
        return base.child("matches")
    }
    var playersRef:FIRDatabaseReference {
        return base.child("players")
    }
    var leaguePlayersRef:FIRDatabaseReference {
        return base.child("leaguePlayers")
    }
    
    init() {
        FIRApp.configure()
        self.base = FIRDatabase.database().reference()
    }
    
    func test() {
        self.base.child("users").setValue(["username": "test username"])
    }
    
}