//
//  LeagueManager.swift
//  duelly
//
//  Created by Andrew Schreiber on 6/16/16.
//  Copyright © 2016 hi_hu. All rights reserved.
//

import Foundation
import Firebase

class LeagueManager {
    static let sharedInstance = LeagueManager()
    
    func getLeagues(callback:[League] -> ()) {
        APIClient.sharedClient.base.observeSingleEventOfType(.Value, withBlock: { snapshot in
            guard let json = snapshot.value as? [String:AnyObject] else {
                print("Didn't get leagues")
                callback([])
                return
            }
            print("got json \(json)")
            
            
        })
    }
    
    func getMatchesForLeague(league:League, callback:[Match] -> ()) {
        APIClient.sharedClient.matchesRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            guard let json = snapshot.value as? [String:AnyObject] else {
                print("Didn't get matches")
                callback([])
                return
            }
            
            var matches = [Match]()
            
            for (_, value) in json {
                let match = Match(playerAName: value["playerAName"] as! String,
                    playerBName: value["playerBName"] as! String,
                    result: MatchResult(rawValue:value["result"] as! String)!,
                    leagueName: value["leagueName"] as! String)
                matches.append(match)
                
                
            }
            callback(matches)
            
            
        })
    }
    
    func getPlayersForLeague(league:League, callback:[Player] ->()) {
        
        APIClient.sharedClient.playersRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            guard let json = snapshot.value as? [String:AnyObject] else {
                print("Didn't get players")
                callback([])
                return
            }
            
            var players = [Player]()
            
//            for (_, value) in json {
//                let match = Match(playerAName: value["playerAName"] as! String,
//                    playerBName: value["playerBName"] as! String,
//                    result: MatchResult(rawValue:value["result"] as! String)!,
//                    leagueName: value["leagueName"] as! String)
//                matches.append(match)
//                
//                
//            }
//            callback(matches)
            
            
        })
    }
    
    func submitMatch(match:Match, callback:Bool ->()) {
        APIClient.sharedClient.matchesRef.childByAutoId().setValue(
        match.dictionary) { (error , ref) in
            if let error = error {
                print("Got submit match error: \(error.localizedDescription)")
                callback(false)
                return
            }
            callback(true)
        }
        
    }
    
    func createLeague(league:League, callback: Bool -> ()) {
        let child = APIClient.sharedClient.leaguesRef.childByAutoId()
        var dict = league.dictionary
        dict["ref"] = child
        
        child.setValue(
        league.dictionary) { (error , ref) in
            if let error = error {
                print("Got create league error: \(error.localizedDescription)")
                callback(false)
                return
            }
            callback(true)
        }
    }
}

struct League {
    var ref:String
    let name:String
    let description:String
    let password:String
    let rubric:Rubric
    
    static func testLeague() -> League{
        return League(ref: "", name: "Test League", description: "A league to test with", password: "abc", rubric: Rubric.testRubric())
    }
    
    var dictionary:[String:AnyObject] {
        return [
            "name" : name,
            "description": description,
            "password" : password,
            "rubric": rubric.dictionary
        ]
    }
    
}

struct Rubric {
    let winPoints:Float
    let lossPoints:Float
    let drawPoints:Float
    
    func scoreForRecord(record:MatchRecord) -> Float {
        let (wins, losses, draws) = record
        return (Float(wins) * winPoints) + (Float(losses) * lossPoints) + (Float(draws) * drawPoints)
    }
    
    static func testRubric() -> Rubric {
        return Rubric(winPoints: 4, lossPoints: 2, drawPoints: 2)
    }
    var dictionary:[String:AnyObject] {
        return [
        "winPoints": winPoints,
        "lossPoints": lossPoints,
        "drawPoints" : drawPoints
        ]
    }

}

struct Match {
    let playerAName:String
    let playerBName:String
    let result:MatchResult
    let leagueName:String
    
    var dictionary:[String:AnyObject] {
        return [
        "playerAName": playerAName,
        "playerBName": playerBName,
        "result": result.rawValue,
        "leagueName": leagueName
        ]
    }
    
    
}

struct Player {
    let name:String
    let matches:[Match]
    
    var leagueID:String?
    var playerID:String?
    
    func recordForMatches(matches:[Match]) -> MatchRecord {
        let myMatches = matches.filter{ $0.playerAName == name || $0.playerBName == name }
        var wins:Int = 0
        var losses:Int = 0
        var draws:Int = 0
        
        for match in myMatches {
            if (match.playerAName == name && match.result == .PlayerAWon) || (match.playerBName == name && match.result == .PlayerBWon) {
                wins += 1
            } else if match.result == .Draw {
                draws += 1
            } else {
                losses += 1
            }
        }
        
        return MatchRecord(wins, losses, draws)
    }
}


typealias MatchRecord = (wins:Int, losses:Int, draws: Int)

enum MatchResult:String {
    case PlayerAWon = "Player A won"
    case PlayerBWon = "Player B won"
    case Draw = "Draw"
    case Unplayed = "Unplayed"
}
