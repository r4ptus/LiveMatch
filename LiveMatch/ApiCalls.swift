//
//  ApiCalls.swift
//  LiveMatch
//
//  Created by ema on 03.07.19.
//  Copyright © 2019 raptus. All rights reserved.
//

import Foundation
import LeagueAPI

struct ApiCalls {
    static let league = LeagueAPI(APIToken: "RGAPI-637e2361-b94d-47e4-8248-0e523acdd9f9")
    //get the active game data if the player is in game, otherwise go to profile page
    static func getLiveMatch(summonerName: String, viewController: ViewController) {
        league.riotAPI.getSummoner(byName: summonerName, on: .EUW) { (summoner, errorMsg) in
            if let summoner = summoner {
                print("Summoner exist")
                self.league.riotAPI.getLiveGame(by: summoner.id, on: .EUW, handler: { (gameInfo, errorMsg) in
                    if let gameInfo = gameInfo {
                        viewController.gameInfo = gameInfo
                        print("Player is in game")
                        
                        DispatchQueue.main.async {
                            viewController.performSegue(withIdentifier: "segueToGameDataView", sender: self)
                        }
                    } else {
                        viewController.summoner = summoner
                        print("Request failed cause: \(errorMsg ?? "No active game was found")")
                        DispatchQueue.main.async {
                            viewController.performSegue(withIdentifier: "segueToSummonerView", sender: self)
                        }
                    }
                })
            } else {
                print("Request failed cause: \(errorMsg ?? "No error description")")
            }
        }
    }
    static func getRankedStats(summonerId: SummonerId, viewController: SummonerProfileViewController){
        league.riotAPI.getRankedEntries(for: summonerId, on: .EUW) { (rankedEntries, errorMsg) in
            if let rankedEntries = rankedEntries {
                print("Success!")
                viewController.rankedEntries = rankedEntries
                viewController.printRankStats()
            }
            else {
                print("Request failed cause: \(errorMsg ?? "No error description")")
            }
        }
    }
}
