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
                bannedCBlue?.append(champion)
            }
            else {
                bannedCRed?.append(champion)
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
            if indexPath.row == 0 {
                cell.backgroundColor = UIColor.blue
            }
            else if indexPath.row == 1{
                cell.backgroundColor = UIColor.red
            }
            return cell
        }
        else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath) as? TeamTableViewCell else { return TeamTableViewCell()}
            cell.name.text = teamRed![indexPath.row].summonerName
            ApiCalls.league.getProfileIcon(by: teamRed![indexPath.row].profileIconId) { (profileIcon, errorMsg) in
                if let profileIcon = profileIcon {
                    cell.icon.sd_setImage(with: URL(string: profileIcon.profileIcon.url), placeholderImage: UIImage(named: "placeholder.png"))
                }
                else {
                    print("Request failed cause: \(errorMsg ?? "No error description")")
                }
            }
            ApiCalls.league.getChampionDetails(by: teamRed![indexPath.row].championId, handler: { (championDetails, errorMsg) in
                if let championDetails = championDetails {
                    cell.champion.sd_setImage(with: URL(string: championDetails.images!.square.url), placeholderImage: UIImage(named: "placeholder.png"))
                }
                else {
                    print("Request failed cause: \(errorMsg ?? "No error description")")
                }
            })
            
            return cell
        }
        else {
            guard let cell =  tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath) as? TeamTableViewCell else { return TeamTableViewCell()}
            cell.name.text = teamBlue![indexPath.row].summonerName
            ApiCalls.league.getProfileIcon(by: teamBlue![indexPath.row].profileIconId) { (profileIcon, errorMsg) in
                if let profileIcon = profileIcon {
                    cell.icon.sd_setImage(with: URL(string: profileIcon.profileIcon.url), placeholderImage: UIImage(named: "placeholder.png"))
                }
                else {
                    print("Request failed cause: \(errorMsg ?? "No error description")")
                }
            }
            ApiCalls.league.getChampionDetails(by: teamBlue![indexPath.row].championId, handler: { (championDetails, errorMsg) in
                if let championDetails = championDetails {
                    cell.champion.sd_setImage(with: URL(string: championDetails.images!.square.url), placeholderImage: UIImage(named: "placeholder.png"))
                }
                else {
                    print("Request failed cause: \(errorMsg ?? "No error description")")
                }
            })
            return cell
        }
    }
}
