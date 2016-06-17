//
//  LeagueManager.swift
//  duelly
//
//  Created by Andrew Schreiber on 6/16/16.
//  Copyright © 2016 hi_hu. All rights reserved.
//

import Foundation

class LeagueManager {
    static let sharedInstance = LeagueManager()
    
    func getLeagues(callback:[League] -> ()) {
        
    }
    
    func getMatchesForLeague(league:League, callback:[Match] -> ()) {
        
    }
    
    func submitMatch(match:Match, callback:Bool ->()) {
        
    }
}

struct League {
    let leagueID:String
    let name:String
    let description:String
    let password:String
    let rubric:Rubric
}

struct Rubric {
    let winPoints:Float
    let lossPoints:Float
    let drawPoints:Float
    
    func scoreForRecord(record:MatchRecord) -> Float {
        let (wins, losses, draws) = record
        return (Float(wins) * winPoints) + (Float(losses) * lossPoints) + (Float(draws) * drawPoints)
    }
}

struct Match {
    let playerAName:String
    let playerBName:String
    let result:MatchResult
    let leagueName:String
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

enum MatchResult {
    case PlayerAWon
    case PlayerBWon
    case Draw
    case Unplayed
}
