//
//  SummonerProfileViewController.swift
//  LiveMatch
//
//  Created by ema on 27.06.19.
//  Copyright © 2019 raptus. All rights reserved.
//

import UIKit
import LeagueAPI
import SDWebImage

class SummonerProfileViewController: UIViewController {

    var summoner: Summoner?
    var rankedEntries: [RankedEntry]?
    
    @IBOutlet var summonerIcon: UIImageView!
    @IBOutlet var summonerName: UILabel!
    @IBOutlet var flex3Rank: CardView!
    @IBOutlet var soloQRank: CardView!
    @IBOutlet var flex5Ranked: CardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        summonerName.text = summoner!.name
        
        flex5Ranked.queueType.text = "Flex 5"
        soloQRank.queueType.text = "Solo Q"
        flex3Rank.queueType.text = "Flex 3"
        
        ApiCalls.league.getProfileIcon(by: summoner!.iconId) { (profileIcon, errorMsg) in
            if let profileIcon = profileIcon {
                print("Success!")
                self.summonerIcon.sd_setImage(with: URL(string: profileIcon.profileIcon.url), placeholderImage: UIImage(named: "placeholder.png"))
            }
            else {
                print("Request failed cause: \(errorMsg ?? "No error description")")
            }
        }
        
        ApiCalls.getRankedStats(summonerId: summoner!.id, viewController: self)
    }    
    public func printRankStats() {
        for item in rankedEntries! {
            switch item.queue.type {
                case Queue.QueueTypes.RankedFlex3V3:
                    DispatchQueue.main.async {
                        self.flex3Rank.rank.text = "\(item.tier.tier) \(item.leagueInfo.rank)"
                        self.flex3Rank.wins.text = "W \(item.leagueInfo.wins)"
                        self.flex3Rank.loses.text = "L \(item.leagueInfo.losses)"
                        self.flex3Rank.leaguePoints.text = "\(item.leagueInfo.leaguePoints) LP"
                    }
                    break
                case Queue.QueueTypes.RankedFlex5V5:
                    DispatchQueue.main.async {
                        self.flex5Ranked.rank.text = "\(item.tier.tier) \(item.leagueInfo.rank)"
                        self.flex5Ranked.wins.text = "W \(item.leagueInfo.wins)"
                        self.flex5Ranked.loses.text = "L \(item.leagueInfo.losses)"
                        self.flex5Ranked.leaguePoints.text = "\(item.leagueInfo.leaguePoints) LP"
                    }
                    break
                case Queue.QueueTypes.RankedSolo5V5:
                    DispatchQueue.main.async {
                        self.soloQRank.rank.text = "\(item.tier.tier) \(item.leagueInfo.rank)"
                        self.soloQRank.wins.text = "W \(item.leagueInfo.wins)"
                        self.soloQRank.loses.text = "L \(item.leagueInfo.losses)"
                        self.soloQRank.leaguePoints.text = "\(item.leagueInfo.leaguePoints) LP"
                    }
                    break
                default:
                    break
            }
        }
    }
}
