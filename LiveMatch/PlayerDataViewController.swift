//
//  PlayerDataViewController.swift
//  LiveMatch
//
//  Created by ema on 27.06.19.
//  Copyright © 2019 raptus. All rights reserved.
//

import UIKit
import LeagueAPI
import SDWebImage

enum TableSections: Int {
    case rankedStats = 0
    case soloq
    case flex3
    case flex5
    case spells
    case masteries
    case masterie1
    case masterie2
}

class PlayerDataViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    var summoner: Participant?
    var rankedEntries: [RankedEntry]?
    var soloEntry: Bool = false
    var flex3Entry: Bool = false
    var flex5Entry: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        self.title = "\(summoner!.summonerName)"
        checkRankedEntry()
        
        ApiCalls.getRankedStats(summonerId: summoner!.summonerId!, viewController: self)
    }
    func checkRankedEntry() {
        guard let rankedEntries = rankedEntries  else { return }
        for entry in rankedEntries {
            switch entry.queue.type {
            case Queue.QueueTypes.RankedSolo5V5:
                soloEntry = true
                break
            case Queue.QueueTypes.RankedFlex5V5:
                flex5Entry = true
                break
            case Queue.QueueTypes.RankedFlex3V3:
                flex3Entry = true
                break
            default:
                break
            }
        }
    }
}
extension PlayerDataViewController: UITableViewDelegate,UITableViewDataSource {
        func tableView(_ tableView:UITableView, heightForRowAt indexPath:IndexPath)->CGFloat {
            return 44
        }
        func numberOfSections(in tableView: UITableView) -> Int {
            return 8
        }
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            switch section {
            case TableSections.rankedStats.rawValue:
                return 40
            case TableSections.soloq.rawValue:
                return 30
            case TableSections.flex3.rawValue:
                return 30
            case TableSections.flex5.rawValue:
                return 30
            case TableSections.spells.rawValue:
                return 40
            case TableSections.masteries.rawValue:
                return 40
            case TableSections.masterie1.rawValue:
                return 30
            case TableSections.masterie2.rawValue:
                return 30
            default:
                return 0
            }
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            switch section {
            case TableSections.rankedStats.rawValue:
                return 0
            case TableSections.soloq.rawValue:
                if(soloEntry){
                    return 1
                }
                return 0
            case TableSections.flex3.rawValue:
                if(flex3Entry){
                    return 1
                }
                return 0
            case TableSections.flex5.rawValue:
                if(flex5Entry){
                    return 1
                }
                return 0
            case TableSections.spells.rawValue:
                return 2
            case TableSections.masteries.rawValue:
                return 0
            case TableSections.masterie1.rawValue:
                return 4
            case TableSections.masterie2.rawValue:
                return 2
            default:
                return 0
            }
        }
        
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            switch section {
            case TableSections.rankedStats.rawValue:
                return "Ranked Stats"
            case TableSections.soloq.rawValue:
                return "Solo Q"
            case TableSections.flex3.rawValue:
                return "Flex 3vs3"
            case TableSections.flex5.rawValue:
                return "Flex 5vs5"
            case TableSections.spells.rawValue:
                return "Spells"
            case TableSections.masteries.rawValue:
                return "Masteries"
            case TableSections.masterie1.rawValue:
                return ApiCalls.runePathesDictionary[summoner!.runePage!.primaryPath]!.name
            case TableSections.masterie2.rawValue:
                return ApiCalls.runePathesDictionary[summoner!.runePage!.secondaryPath]!.name
            default:
                return ""
            }
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            switch indexPath.section {
            case TableSections.soloq.rawValue:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "RankedCell", for: indexPath) as? RankedTableViewCell else { return RankedTableViewCell()}
                for entry in rankedEntries! {
                    if entry.queue.type == Queue.QueueTypes.RankedSolo5V5 {
                        populateRankedCells(cell: cell, entry: entry)
                    }
                }
                return cell
            case TableSections.flex3.rawValue:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "RankedCell", for: indexPath) as? RankedTableViewCell else { return RankedTableViewCell()}
                for entry in rankedEntries! {
                    if entry.queue.type == Queue.QueueTypes.RankedFlex3V3 {
                        populateRankedCells(cell: cell, entry: entry)
                    }
                }
                return cell
            case TableSections.flex5.rawValue:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "RankedCell", for: indexPath) as? RankedTableViewCell else { return RankedTableViewCell()}
                for entry in rankedEntries! {
                    if entry.queue.type == Queue.QueueTypes.RankedFlex5V5 {
                        populateRankedCells(cell: cell, entry: entry)
                    }
                }
                return cell
            case TableSections.spells.rawValue:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "RuneCell", for: indexPath) as? RuneTableViewCell else { return RuneTableViewCell()}
                if indexPath.row == 0 {
                    cell.runeImage.sd_setImage(with: URL(string: ApiCalls.summonerSpellsDictionary[summoner!.summonerSpell1]!.image.url), placeholderImage: UIImage(named: "placeholder.png"))
                    cell.name.text = ApiCalls.summonerSpellsDictionary[summoner!.summonerSpell1]!.name
                }
                else {
                    cell.runeImage.sd_setImage(with: URL(string: ApiCalls.summonerSpellsDictionary[summoner!.summonerSpell2]!.image.url), placeholderImage: UIImage(named: "placeholder.png"))
                    cell.name.text = ApiCalls.summonerSpellsDictionary[summoner!.summonerSpell2]!.name
                }
                return cell
            case TableSections.masterie1.rawValue:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "RuneCell", for: indexPath) as? RuneTableViewCell else { return RuneTableViewCell()}
                for runeStage in ApiCalls.runePathesDictionary[summoner!.runePage!.primaryPath]!.runeStages {
                    for rune in runeStage.runes{
                        if rune.id == summoner!.runePage?.runeIds[indexPath.row] {
                            cell.name.text = rune.name
                            cell.runeImage.sd_setImage(with: URL(string: rune.image.url), placeholderImage: UIImage(named: "placeholder.png"))
                        }
                    }
                }
                return cell
            case TableSections.masterie2.rawValue:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "RuneCell", for: indexPath) as? RuneTableViewCell else { return RuneTableViewCell()}
                for runeStage in ApiCalls.runePathesDictionary[summoner!.runePage!.secondaryPath]!.runeStages {
                    for rune in runeStage.runes{
                        if rune.id == summoner!.runePage?.runeIds[indexPath.row+4] {
                            cell.name.text = rune.name
                            cell.runeImage.sd_setImage(with: URL(string: rune.image.url), placeholderImage: UIImage(named: "placeholder.png"))
                        }
                    }
                }
                return cell
            default:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "RuneCell", for: indexPath) as? RuneTableViewCell else { return RuneTableViewCell()}
                return cell
            }
        }
    public func printRankStats() {
        checkRankedEntry()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    private func populateRankedCells(cell: RankedTableViewCell, entry: RankedEntry) {
        cell.tier.sizeToFit()
        cell.tier.text = "\(entry.tier.tier) \(entry.leagueInfo.rank)"
        cell.wins.sizeToFit()
        cell.wins.text = "W \(entry.leagueInfo.wins)"
        cell.loses.sizeToFit()
        cell.loses.text = "L \(entry.leagueInfo.losses)"
        cell.leaguePoints.sizeToFit()
        cell.leaguePoints.text = "\(entry.leagueInfo.leaguePoints) LP"
    }
}

