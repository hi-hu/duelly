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
    
    var user:FIRUser?
    
    var player:Player?
        
    var league:League?
    
    // MARK: Get array
    private func getArray<T:Mappable>(ref:FIRDatabaseReference, callback:[T] ->()) {
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            guard let json = snapshot.value as? [String:AnyObject] else {
                print("Didn't get array of \(T.self). Got: \(snapshot.value)")
                callback([])
                return
            }
            print("Got array of \(T.self). JSON \(json)")
            
            var array = [T]()
            
            for (_,value) in json {
                if let element = Mapper<T>().map(value) {
                    array.append(element)
                } else {
                    print("Couldn't serialize \(T.self). \(value)")
                }
            }
            callback(array)
        })
    }
    
    func getLeagues(callback:[League] -> ()) {
        LeagueManager.sharedInstance.getArray(APIClient.sharedClient.leaguesRef, callback: callback)
    }
    
    func getMatchesForLeague(league:League, callback:[Match] -> ()) {
        let matchesRef = APIClient.sharedClient.matchesRef.child(league.autoID)
        LeagueManager.sharedInstance.getArray(matchesRef, callback: callback)
    }
    
    func getPlayersForLeague(league:League, callback:[Player] ->()) {
        let playersRef = APIClient.sharedClient.leaguePlayersRef.child(league.autoID)
        LeagueManager.sharedInstance.getArray(playersRef, callback: callback)
    }
    
    // MARK: Create
    private func createObject<T:Mappable>(object:T, ref:FIRDatabaseReference, callback:Bool ->()) {
        let child = ref.childByAutoId()
        let dict = object.toJSON()
        
        child.setValue(dict) { (error , ref) in
            if let error = error {
                print("Got create \(T.self) error: \(error.localizedDescription)")
                callback(false)
            } else {
                callback(true)
            }
        }
    }
    
    func createLeague(league:League, callback: Bool -> ()) {
        createObject(league, ref: APIClient.sharedClient.leaguesRef, callback: callback)
    }
    
    // MARK: Add to league
    
    private func addToLeague<T:Mappable>(leagueID:String, obj:T, ref:FIRDatabaseReference, callback:Bool ->()) {
        let child = ref.child(leagueID).childByAutoId()
        let dict = obj.toJSON()
        
        child.setValue(dict) { (error , ref) in
            if let error = error {
                print("Got submit \(T.self) error: \(error.localizedDescription)")
                callback(false)
            } else {
                callback(true)
            }
        }
    }
    
    func submitMatch(match:Match, callback:Bool ->()) {
        addToLeague(match.leagueID, obj: match, ref: APIClient.sharedClient.matchesRef, callback: callback)
    }
    
    func addPlayerToLeague(player:Player, league:League, callback:Bool ->()) {
        var player = player
        player.leagueID = league.autoID
        addToLeague(league.autoID, obj: player, ref: APIClient.sharedClient.leaguePlayersRef, callback: callback)
    }
    
    // MARK: Replace object
    
    private func replaceObject<T:Baseable>(obj:T, ref:FIRDatabaseReference, callback:Bool -> ()) {
        
        let child = ref.child(obj.autoID)
        let dict = obj.toJSON()
        child.setValue(dict) { (error , ref) in
            if let error = error {
                print("Got replace \(T.self) error: \(error.localizedDescription)")
                callback(false)
            } else {
                callback(true)
            }
        }
    }
    
    func replaceLeague(league:League, callback:Bool -> ()) {
        replaceObject(league, ref: APIClient.sharedClient.leaguesRef, callback: callback)
    }
    
    func replaceMatch(match:Match, callback:Bool -> ()) {
        replaceObject(match, ref: APIClient.sharedClient.matchesRef, callback: callback)
    }
}

struct League: Baseable {
    var autoID:String
    var name:String
    var description:String
    var password:String
    let rubric = Rubric(winPoints: 4, lossPoints: 2, drawPoints: 2, byePoints: 4)
    
    static func testLeague() -> League{
        return League(name: "Test League", description: "A league to test with", password: "abc")
    }
    
    init(name:String, description:String, password:String) {
        let child = APIClient.sharedClient.leaguesRef.childByAutoId()
        let id = child.description().componentsSeparatedByString("/").last!
        self.autoID = id
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

struct Player: Baseable {
    var name:String
    var autoID:String
    var leagueID:String?
    
    init(name:String ) {
        let child = APIClient.sharedClient.leaguePlayersRef.childByAutoId()
        let id = child.description().componentsSeparatedByString("/").last!
        self.autoID = id
        self.name = name
    }
    
    init?(_ map: Map) {
        self.name = map["name"].value() ?? "Unnamed Player"
        self.autoID = map["autoID"].value() ?? ""
        self.leagueID = map["leagueID"].value()
    }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        leagueID <- map["leagueID"]
        autoID <- map["autoID"]
    }
}

struct Rubric {
    let winPoints:Float
    let lossPoints:Float
    let drawPoints:Float
    let byePoints:Float
    
    func scoreForRecord(record:MatchRecord) -> Float {
        let (wins, losses, draws, byes) = record
        return (Float(wins) * winPoints) + (Float(losses) * lossPoints) + (Float(draws) * drawPoints) + (Float(byes) * byePoints)
    }
}

typealias MatchRecord = (wins:Int, losses:Int, draws: Int, byes:Int)

enum MatchResult:String {
    case PlayerAWon = "Player A won"
    case PlayerBWon = "Player B won"
    case Draw = "Draw"
    case Unplayed = "Unplayed"
    case PlayerABye = "Player A bye"
}

protocol Baseable:Mappable {
    var autoID:String { get set }
}

struct Match:Baseable {
    var playerAName:String
    var playerBName:String
    var result:MatchResult
    var leagueID:String
    var autoID:String
    
    init(playerAName:String, playerBName:String, result:MatchResult, leagueID:String) {
        let child = APIClient.sharedClient.matchesRef.childByAutoId()
        let id = child.description().componentsSeparatedByString("/").last!
        self.autoID = id
        self.playerAName = playerAName
        self.playerBName = playerBName
        self.result = result
        self.leagueID = leagueID
    }
    
    init?(_ map: Map) {
        self.playerAName = map["playerAName"].value() ?? ""
        self.playerBName = map["playerBName"].value() ?? ""
        self.result = map["result"].value() ?? .Unplayed
        self.leagueID = map["leagueID"].value() ?? ""
        self.autoID = map["autoID"].value() ?? ""
    }
    
    mutating func mapping(map: Map) {
        playerAName <- map["playerAName"]
        playerBName <- map["playerBName"]
        result <- (map["result"], EnumTransform<MatchResult>())
        leagueID <- map["leagueID"]
        autoID <- map["autoID"]
    }
}

extension SequenceType where Generator.Element == Match {
    
    var players:[String] {
        var players = [String]()
        
        for match in self {
            if !players.contains(match.playerAName) {
                players.append(match.playerAName)
            } else if !players.contains(match.playerBName) {
                players.append(match.playerBName)
            }
        }

        return players
    }
    
    func leagueRankByName(rubric:Rubric) -> [String] {
        var rankTuple = [(String, Float)]()
        
        for player in players {
            let matches = matchesForPlayerName(player)
            let record = matches.recordForName(player)
            let score = rubric.scoreForRecord(record)
            rankTuple.append((player,score))
        }
        
        let sortedTuple = rankTuple.sort { a,b -> Bool in
            return a.1 > b.1 // Higher score first. The '.1' is the score value.
        }
        
        let sortedNames = sortedTuple.map { tuple in
            return tuple.0 // Get the name of the player for each tuple.
        }
        
        return sortedNames
    }
    
    func matchesForPlayerName(name:String) -> [Match] {
        
        // Imperative
//        var myMatches = [Match]()
//        for match in self {
//            if match.playerAName == name || match.playerBName == name {
//                myMatches.append(match)
//            }
//        }
//        return myMatches
        
        // Functional
        return filter { $0.playerAName == name || $0.playerBName == name }
    }
    
    func recordForName(name:String) -> MatchRecord {
        var wins:Int = 0
        var losses:Int = 0
        var draws:Int = 0
        var byes:Int = 0
        
        for match in self {
            guard match.playerAName == name || match.playerBName == name else {
                continue
            }
            
            if (match.playerAName == name && match.result == .PlayerAWon) || (match.playerBName == name && match.result == .PlayerBWon) {
                wins += 1
            } else if match.result == .Draw {
                draws += 1
            } else if match.result == .PlayerABye {
                byes += 1
            } else {
                losses += 1
            }
        }
        
        return MatchRecord(wins, losses, draws, byes)
    }
    
}
