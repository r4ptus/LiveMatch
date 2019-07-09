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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain,
                                                            target: self, action: #selector(share(sender:)))
        summonerName.text = summoner!.name
        flex5Ranked.queueType.text = "Flex 5"
        soloQRank.queueType.text = "Solo Q"
        flex3Rank.queueType.text = "Flex 3"
        flex5Ranked.icon.image = ApiCalls.tierEmblems[RankedTier.Tiers.Unranked]
        flex3Rank.icon.image = ApiCalls.tierEmblems[RankedTier.Tiers.Unranked]
        soloQRank.icon.image = ApiCalls.tierEmblems[RankedTier.Tiers.Unranked]
        summonerIcon.sd_setImage(with: URL(string: ApiCalls.profileIcons[summoner!.iconId]!.profileIcon.url),
                                 placeholderImage: UIImage(named: "placeholder.png"))
        ApiCalls.getRankedStats(summonerId: summoner!.id, viewController: self)
    }
    /**
     prints the ranked stats to their cards
     */
    public func printRankStats() {
        for item in rankedEntries! {
            switch item.queue.type {
            case Queue.QueueTypes.RankedFlex3V3:
                    DispatchQueue.main.async {
                        self.flex3Rank.icon.image = ApiCalls.tierEmblems[item.tier.tier]
                        self.flex3Rank.rank.text = "\(item.tier.tier) \(item.leagueInfo.rank)"
                        self.flex3Rank.leaguePoints.text = "\(item.leagueInfo.leaguePoints) LP"
                    }
            case Queue.QueueTypes.RankedFlex5V5:
                    DispatchQueue.main.async {
                        self.flex5Ranked.icon.image = ApiCalls.tierEmblems[item.tier.tier]
                        self.flex5Ranked.rank.text = "\(item.tier.tier) \(item.leagueInfo.rank)"
                        self.flex5Ranked.leaguePoints.text = "\(item.leagueInfo.leaguePoints) LP"
                    }
            case Queue.QueueTypes.RankedSolo5V5:
                    DispatchQueue.main.async {
                        self.soloQRank.icon.image = ApiCalls.tierEmblems[item.tier.tier]
                        self.soloQRank.rank.text = "\(item.tier.tier) \(item.leagueInfo.rank)"
                        self.soloQRank.leaguePoints.text = "\(item.leagueInfo.leaguePoints) LP"
                    }
            default:
                    break
            }
        }
    }/**
     share action
     
     - Parameters:
     - sender: UIView
     */
    @objc func share(sender: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let textToShare = "Check out my profile"
        let objectsToShare = [textToShare, image ?? #imageLiteral(resourceName: "app-logo")] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        //Excluded Activities
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        //
        activityVC.popoverPresentationController?.sourceView = sender
        self.present(activityVC, animated: true, completion: nil)
    }
}
