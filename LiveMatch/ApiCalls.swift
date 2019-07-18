//
//  ApiCalls.swift
//  LiveMatch
//
//  Created by ema on 03.07.19.
//  Copyright © 2019 raptus. All rights reserved.
//

import Foundation
import LeagueAPI
///struct with all the functions to get the API data
struct ApiCalls {
    ///Dictionary for all champions get champion by ID
    static var champions = [ChampionId: ChampionDetails]()
    ///Dictionary for all profileicons get icon by ID
    static var profileIcons = [ProfileIconId: ProfileIcon]()
    ///Dictionary for all runepathes get runepath by ID
    static var runePathesDictionary = [RunePathId: RunePath]()
    ///Dictionary for all summonerspells get spell by ID
    static var summonerSpellsDictionary = [SummonerSpellId: SummonerSpell]()
    ///Dictionary for all ranked tiers get uiimage by rankedtier
    static var tierEmblems: [RankedTier.Tiers: UIImage] = [RankedTier.Tiers.Iron: UIImage(named: "emblem_iron")!,
                                                          RankedTier.Tiers.Bronze: UIImage(named: "emblem_bronze")!,
                                                          RankedTier.Tiers.Silver: UIImage(named: "emblem_silver")!,
                                                          RankedTier.Tiers.Gold: UIImage(named: "emblem_gold")!,
                                                          RankedTier.Tiers.Platinum: UIImage(named: "emblem_platinum")!,
                                                          RankedTier.Tiers.Diamond: UIImage(named: "emblem_diamond")!,
                                                          RankedTier.Tiers.Master: UIImage(named: "emblem_master")!,
                                                          RankedTier.Tiers.GrandMaster:
                                                            UIImage(named: "emblem_grandmaster")!,
                                                          RankedTier.Tiers.Challenger:
                                                            UIImage(named: "emblem_challenger")!,
                                                          RankedTier.Tiers.Unranked: UIImage(named: "unranked")!]
    ///Api key
    static let league = LeagueAPI(APIToken: "RGAPI-637e2361-b94d-47e4-8248-0e523acdd9f9")
    /**
     gets the live date for the summoner,
     if the summoner is in game go to game data
     if the summoner isnt in game go to profile
     
     - Parameters:
        - summonerName: the name of the summoner
        - viewController: the viewController who calls this func
     */
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
                DispatchQueue.main.async {
                    viewController.showToast(controller: viewController.self,
                                             message: "Request failed cause: \(errorMsg ?? "No error description")",
                        seconds: 15)
                    viewController.progressHUD?.hide()
                }
            }
        }
    }
    /**
     gets the ranked stats of the summoner
     
     - Parameters:
        - summonerId: id of the summoner
        - viewController: viewController which calls the func
     */
    static func getRankedStats(summonerId: SummonerId, viewController: UIViewController) {
        league.riotAPI.getRankedEntries(for: summonerId, on: .EUW) { (rankedEntries, errorMsg) in
            if let rankedEntries = rankedEntries {
                print("Success!")
                switch viewController {
                case is SummonerProfileViewController:
                    guard let svc = viewController
                        as? SummonerProfileViewController else { return }
                    svc.rankedEntries = rankedEntries
                    svc.printRankStats()
                case is PlayerDataViewController:
                    guard let pvc = viewController
                        as? PlayerDataViewController else { return }
                    pvc.rankedEntries = rankedEntries
                    pvc.printRankStats()
                default:
                    break
                }
            } else {
                print("Request failed cause: \(errorMsg ?? "No error description")")
                DispatchQueue.main.async {
                    viewController.showToast(controller: viewController.self,
                                             message: "Request failed cause: \(errorMsg ?? "No error description")",
                        seconds: 15)
                }
            }
        }
    }
    /**
     entrypoint to fetch all necessary data
     gets all champions and put them in a dictionary
     
     - Parameters:
        - viewController: viewController which calls the func
     */
    static func getChampions(viewController: ViewController) {
        league.getAllChampionIds { (championIds, errorMsg) in
            if let championIds = championIds {
                print("Success!")
                for champion in championIds {
                    league.getChampionDetails(by: champion, handler: { (championDetails, errorMsg) in
                        if let championDetails = championDetails {
                            champions[championDetails.championId] = championDetails
                            if champions.count == championIds.count {
                                print("finished getChampions")
                                getIcons(viewController: viewController)
                            }
                        } else {
                            print("Request failed cause: \(errorMsg ?? "No error description")")
                            viewController.showAlert(errorMsg:
                                "Request failed cause: \(errorMsg ?? "No error description")")
                        }
                    })
                }
            } else {
                print("Request failed cause: \(errorMsg ?? "No error description")")
                viewController.showAlert(errorMsg: "Request failed cause: \(errorMsg ?? "No error description")")
            }
        }
    }
    /**
     gets all icons and put them in a dictionary
     
     - Parameters:
        - viewController: viewController which calls the func
     */
    private static func getIcons(viewController: ViewController) {
        league.getProfileIconIds { (iconIds, errorMsg) in
            if let iconIds = iconIds {
                print("Success!")
                for iconId in iconIds {
                    league.getProfileIcon(by: iconId, handler: { (profileIcon, errorMsg) in
                        if let profileIcon = profileIcon {
                            profileIcons[profileIcon.id] = profileIcon
                            if profileIcons.count == iconIds.count {
                                print("finished profileIcons")
                                getRunes(viewController: viewController)
                            }
                        } else {
                            print("Request failed cause: \(errorMsg ?? "No error description")")
                            viewController.showAlert(errorMsg:
                                "Request failed cause: \(errorMsg ?? "No error description")")
                        }
                    })
                }
            } else {
                print("Request failed cause: \(errorMsg ?? "No error description")")
                viewController.showAlert(errorMsg: "Request failed cause: \(errorMsg ?? "No error description")")
            }
        }
    }
    /**
     gets all runes and put them in a dictionary
     
     - Parameters:
        - viewController: viewController which calls the func
     */
    private static func getRunes(viewController: ViewController) {
        league.getRunePaths { (runePaths, errorMsg) in
            if let runePaths = runePaths {
                print("Success!")
                for runePath in runePaths {
                    runePathesDictionary[runePath.id] = runePath
                }
                print("finished runes")
                getSummonerSpells(viewController: viewController)
            } else {
                print("Request failed cause: \(errorMsg ?? "No error description")")
                viewController.showAlert(errorMsg: "Request failed cause: \(errorMsg ?? "No error description")")
            }
        }
    }
    /**
     end of the data fetching
     gets all summoner spells and put them in a dictionary
     
     - Parameters:
        - viewController: viewController which calls the func
     */
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
            } else {
                print("Request failed cause: \(errorMsg ?? "No error description")")
                viewController.showAlert(errorMsg: "Request failed cause: \(errorMsg ?? "No error description")")
            }
        }
    }
}
