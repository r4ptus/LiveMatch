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
    static var champions = [ChampionId: ChampionDetails]()
    static var profileIcons = [ProfileIconId: ProfileIcon]()
    static var runePathesDictionary = [RunePathId: RunePath]()
    static var summonerSpellsDictionary = [SummonerSpellId: SummonerSpell]()
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
    static func getRankedStats(summonerId: SummonerId, viewController: UIViewController){
        league.riotAPI.getRankedEntries(for: summonerId, on: .EUW) { (rankedEntries, errorMsg) in
            if let rankedEntries = rankedEntries {
                print("Success!")
                switch viewController {
                case is SummonerProfileViewController:
                    let vc = viewController as! SummonerProfileViewController
                    vc.rankedEntries = rankedEntries
                    vc.printRankStats()
                    break
                case is PlayerDataViewController:
                    let vc = viewController as! PlayerDataViewController
                    vc.rankedEntries = rankedEntries
                    vc.printRankStats()
                    break
                default:
                    break
                }
            }
            else {
                print("Request failed cause: \(errorMsg ?? "No error description")")
            }
        }
    }
    static func getChampions(viewController: ViewController) {
        league.getAllChampionIds { (championIds, errorMsg) in
            if let championIds = championIds {
                print("Success!")
                for champion in championIds{
                    league.getChampionDetails(by: champion, handler: { (championDetails, errorMsg) in
                        if let championDetails = championDetails {
                            champions[championDetails.championId] = championDetails
                            if champions.count == championIds.count {
                                print("finished getChampions")
                                getIcons(viewController: viewController)
                            }
                        }
                        else {
                            print("Request failed cause: \(errorMsg ?? "No error description")")
                        }
                    })
                }                
            }
            else {
                print("Request failed cause: \(errorMsg ?? "No error description")")
            }
        }
    }
    private static func getIcons(viewController: ViewController){
        league.getProfileIconIds { (iconIds, errorMsg) in
            if let iconIds = iconIds {
                print("Success!")
                for id in iconIds {
                    league.getProfileIcon(by: id, handler: { (profileIcon, errorMsg) in
                        if let profileIcon = profileIcon {
                            profileIcons[profileIcon.id] = profileIcon
                            if profileIcons.count == iconIds.count {
                                print("finished profileIcons")
                                getRunes(viewController: viewController)
                            }
                        }
                        else {
                             print("Request failed cause: \(errorMsg ?? "No error description")")
                        }
                    })
                }
            }
            else {
                print("Request failed cause: \(errorMsg ?? "No error description")")
            }
        }
    }
    private static func getRunes(viewController: ViewController) {
        league.getRunePaths { (runePaths, errorMsg) in
            if let runePaths = runePaths {
                print("Success!")
                for runePath in runePaths {
                    runePathesDictionary[runePath.id] = runePath
                }
                print("finished runes")
                getSummonerSpells(viewController: viewController)
            }
            else {
                print("Request failed cause: \(errorMsg ?? "No error description")")
            }
        }
    }
    private static func getSummonerSpells(viewController: ViewController) {
        league.getSummonerSpells { (summonerSpells, errorMsg) in
            if let summonerSpells = summonerSpells {
                print("Success!")
                for summonerSpell in summonerSpells {
                    summonerSpellsDictionary[summonerSpell.id] = summonerSpell
                }
                print("finished data fetching")
                DispatchQueue.main.async {
                    viewController.searchBar.isUserInteractionEnabled = true
                    viewController.progressHUD?.hide()
                }
            }
            else {
                print("Request failed cause: \(errorMsg ?? "No error description")")
            }
        }
    }
}
