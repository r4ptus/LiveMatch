//
//  GameDataViewController.swift
//  LiveMatch
//
//  Created by ema on 27.06.19.
//  Copyright © 2019 raptus. All rights reserved.
//

import UIKit
import LeagueAPI

class GameDataViewController: UIViewController {

    var gameInfo: GameInfo?
    var teamBlue: [Participant]?
    var teamRed: [Participant]?
    var bannedCBlue: [BannedChampion]?
    var bannedCRed: [BannedChampion]?
    var participantToPass: Participant?
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        teamBlue = [Participant]()
        teamRed = [Participant]()
        bannedCBlue = [BannedChampion]()
        bannedCRed = [BannedChampion]()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        for champion in gameInfo!.bannedChampions {
            if champion.teamId == 100 {
                if champion.championId.value != -1 {
                    bannedCBlue?.append(champion)
                }
            }
            else {
                if champion.championId.value != -1 {
                    bannedCRed?.append(champion)
                }
            }
        }
        for participant in gameInfo!.participants {
            if participant.teamId == 100 {
                teamBlue?.append(participant)
            }
            else {
                teamRed?.append(participant)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pdvc = segue.destination as? PlayerDataViewController {
            pdvc.summoner = participantToPass
        }
    }
    
}
extension GameDataViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView:UITableView, heightForRowAt indexPath:IndexPath)->CGFloat {
        return 44
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            if gameInfo!.bannedChampions.count > 0 {
                return 30
            }
            return 0
        }
        else if section == 1 {
            return 30
        }
        else {
            return 30
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if gameInfo!.bannedChampions.count > 0 {
                return 2
            }
            return 0
        }
        else if section == 1 {
            return teamRed!.count
        }
        else {
            return teamBlue!.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Banned Champions"
        }
        else if section == 1 {
            return "Team Red"
        }
        else {
            return "Team Blue"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "BannedChampionsCell", for: indexPath) as! BannedChampionsTableViewCell
            let bannedChampionsImageViews: [UIImageView] = [cell.champion1,cell.champion2,cell.champion3,cell.champion4,cell.champion5]
            if indexPath.row == 0 {
                cell.backgroundColor = UIColor.blue
                for (index,champion) in bannedCBlue!.enumerated(){
                    bannedChampionsImageViews[index].sd_setImage(with: URL(string: ApiCalls.champions[champion.championId]!.images!.square.url), placeholderImage: UIImage(named: "placeholder.png"))
                }
            }
            else if indexPath.row == 1{
                cell.backgroundColor = UIColor.red
                for (index,champion) in bannedCRed!.enumerated(){
                    bannedChampionsImageViews[index].sd_setImage(with: URL(string: ApiCalls.champions[champion.championId]!.images!.square.url), placeholderImage: UIImage(named: "placeholder.png"))
                }
            }
            return cell
        }
        else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath) as? TeamTableViewCell else { return TeamTableViewCell()}
            cell.name.text = teamRed![indexPath.row].summonerName
            cell.icon.sd_setImage(with: URL(string: ApiCalls.profileIcons[teamRed![indexPath.row].profileIconId]!.profileIcon.url), placeholderImage: UIImage(named: "placeholder.png"))
            cell.champion.sd_setImage(with: URL(string: ApiCalls.champions[teamRed![indexPath.row].championId]!.images!.square.url), placeholderImage: UIImage(named: "placeholder.png"))
            cell.summoner = teamRed![indexPath.row]
            return cell
        }
        else {
            guard let cell =  tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath) as? TeamTableViewCell else { return TeamTableViewCell()}
            cell.name.text = teamBlue![indexPath.row].summonerName
            cell.icon.sd_setImage(with: URL(string: ApiCalls.profileIcons[teamBlue![indexPath.row].profileIconId]!.profileIcon.url), placeholderImage: UIImage(named: "placeholder.png"))
            cell.champion.sd_setImage(with: URL(string: ApiCalls.champions[teamBlue![indexPath.row].championId]!.images!.square.url), placeholderImage: UIImage(named: "placeholder.png"))
            cell.summoner = teamBlue![indexPath.row]
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow!
        guard let currentCell = tableView.cellForRow(at: indexPath)! as? TeamTableViewCell else {return}
        participantToPass = currentCell.summoner!
        performSegue(withIdentifier: "segueToPlayerDataView", sender: self)
    }
}
