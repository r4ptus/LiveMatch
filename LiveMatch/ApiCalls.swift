//
//  ApiCalls.swift
//  LiveMatch
//
//  Created by ema on 27.06.19.
//  Copyright © 2019 raptus. All rights reserved.
//

import Foundation
import LeagueAPI

class ApiCalls{
    
    let league = LeagueAPI(APIToken: "RGAPI-637e2361-b94d-47e4-8248-0e523acdd9f9")
    var summoner : Summoner?
    
    
    func getSummoner(SummonerName: String) {
        league.riotAPI.getSummoner(byName: SummonerName, on: .EUW) { (summoner, errorMsg) in
            if let summoner = summoner {
                self.summoner = summoner
                print("Succes")
            } else {
                print("Request failed cause: \(errorMsg ?? "No error description")")
            }
        }
        
    }
    
}
