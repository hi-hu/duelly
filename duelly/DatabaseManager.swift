//
//  LeagueManager.swift
//  duelly
//
//  Created by Andrew Schreiber on 6/16/16.
//  Copyright © 2016 hi_hu. All rights reserved.
//

import Foundation
import Firebase
import ObjectMapper

class LeagueManager {
    static let sharedInstance = LeagueManager()
    
    private func getArray<T:Mappable>(ref:FIRDatabaseReference, callback:[T] ->()) {
        
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            guard let json = snapshot.value as? [String:AnyObject] else {
                print("Didn't get array of \(T.self)")
                callback([])
                return
            }
            print("Got array of \(T.self). JSON \(json)")
            
            var array = [T]()
            
            for (_,value) in json {
                if let element = Mapper<T>().map(value) {
                    array.append(element)
                } else {
                    print("Couldn't deserialize \(T.self). \(value)")
                }
            }
            callback(array)
        })
    }
    
    
    func getLeagues(callback:[League] -> ()) {
        return LeagueManager.sharedInstance.getArray(APIClient.sharedClient.leaguesRef, callback: callback)
    }
    
    func getMatchesForLeague(league:League, callback:[Match] -> ()) {
        let matchesRef = APIClient.sharedClient.matchesRef.child(league.autoID)
        return LeagueManager.sharedInstance.getArray(matchesRef, callback: callback)
    }
    
    func getPlayersForLeague(league:League, callback:[Player] ->()) {
        let playersRef = APIClient.sharedClient.matchesRef.child(league.autoID)
        return LeagueManager.sharedInstance.getArray(playersRef, callback: callback)
    }
    
    // MARK: Add to server
    
    func createPlayer(player:Player, callback:Bool ->()) {
        let child = APIClient.sharedClient.playersRef.childByAutoId()
        
        var dict = player.toJSON()
        let id = child.description().componentsSeparatedByString("/").last!
    
        dict["autoID"] = id
        
        child.setValue(
        dict) { (error , ref) in
            if let error = error {
                print("Got create player error: \(error.localizedDescription)")
                callback(false)
            } else {
                callback(true)
            }
        }
    }
    
    func createLeague(league:League, callback: Bool -> ()) {
        let child = APIClient.sharedClient.leaguesRef.childByAutoId()
        var dict = league.toJSON()
        let id = child.description().componentsSeparatedByString("/").last!
        
        dict["autoID"] = id
        
        child.setValue(
        dict) { (error , ref) in
            if let error = error {
                print("Got create league error: \(error.localizedDescription)")
                callback(false)
            } else {
                callback(true)
            }
        }
    }
    
    func submitMatch(match:Match, callback:Bool ->()) {
        APIClient.sharedClient.matchesRef.childByAutoId().setValue(
        match.toJSON()) { (error , ref) in
            if let error = error {
                print("Got submit match error: \(error.localizedDescription)")
                callback(false)
            } else {
                callback(true)
            }
        }
    }
    
    func addPlayerToLeague(player:Player, league:League, callback:Bool ->()) {
        
    }
    
}

struct League: Mappable {
    var autoID:String
    var name:String
    var description:String
    var password:String
    let rubric = Rubric(winPoints: 4, lossPoints: 2, drawPoints: 2)
    
    static func testLeague() -> League{
        return League(autoID: "123456", name: "Test League", description: "A league to test with", password: "abc")
    }
    
    init(autoID:String, name:String, description:String, password:String) {
        self.autoID = autoID
        self.name = name
        self.description = description
        self.password = password
    }
    
    init?(_ map: Map) {
        autoID = map["autoID"].value() ?? ""
        name = map["name"].value() ?? ""
        description = map["description"].value() ?? ""
        password = map["password"].value() ?? ""
    }
    
    mutating func mapping(map: Map) {
        autoID <- map["autoID"]
        name <- map["name"]
        description <- map["description"]
        password <- map ["password"]
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
}

struct Match:Mappable {
    var playerAName:String
    var playerBName:String
    var result:MatchResult
    var leagueName:String
    
    init?(_ map: Map) {
        self.playerAName = map["playerAName"].value() ?? ""
        self.playerBName = map["playerBName"].value() ?? ""
        self.result = map["result"].value() ?? .Unplayed
        self.leagueName = map["leagueName"].value() ?? ""
    }
    
    mutating func mapping(map: Map) {
        playerAName <- map["playerAName"]
        playerBName <- map["playerBName"]
        result <- (map["result"], EnumTransform<MatchResult>())
        leagueName <- map["leagueName"]
    }
}

struct Player: Mappable {
    var name:String
    var autoID:String?
    var leagueID:String?
    
    init(name:String) {
        self.name = name
    }
    
    init?(_ map: Map) {
        self.name = map["name"].value() ?? "Unnamed Player"
        self.leagueID = map["leagueID"].value()
    }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        leagueID <- map["leagueID"]
    }
    
    func playerMatches(allMatches:[Match]) -> [Match] {
        return allMatches.filter{ $0.playerAName == name || $0.playerBName == name }
    }
    
    func recordForMatches(matches:[Match]) -> MatchRecord {
        var wins:Int = 0
        var losses:Int = 0
        var draws:Int = 0
        
        for match in matches {
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