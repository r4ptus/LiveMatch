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
            } else {
                if champion.championId.value != -1 {
                    bannedCRed?.append(champion)
                }
            }
        }
        for participant in gameInfo!.participants {
            if participant.teamId == 100 {
                teamBlue?.append(participant)
            } else {
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
    /**
     sets the tableVIew row height
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    /**
     sets the section count for the tableView
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    /**
     sets the height for the section headers
     */
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            if gameInfo!.bannedChampions.count > 0 {
                return 30
            }
            return 0
        } else if section == 1 {
            return 30
        } else {
            return 30
        }
    }
    /**
     sets the numbers of rows in each section
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if gameInfo!.bannedChampions.count > 0 {
                return 2
            }
            return 0
        } else if section == 1 {
            return teamRed!.count
        } else {
            return teamBlue!.count
        }
    }
    /**
     sets the titel for each header
     */
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Banned Champions"
        } else if section == 1 {
            return "Team Red"
        } else {
            return "Team Blue"
        }
    }
    /**
     set each row in the viewtable
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell =  tableView.dequeueReusableCell(withIdentifier: "BannedChampionsCell", for: indexPath)
                as? BannedChampionsTableViewCell else { return BannedChampionsTableViewCell()}
            let bannedChampionsImageViews: [UIImageView] = [cell.champion1, cell.champion2,
                                                            cell.champion3, cell.champion4, cell.champion5]
            if indexPath.row == 0 {
                cell.backgroundColor = UIColor.blue
                for (index, champion) in bannedCBlue!.enumerated() {
                    bannedChampionsImageViews[index].sd_setImage(with:
                        URL(string: ApiCalls.champions[champion.championId]!.images!.square.url),
                                                                 placeholderImage: UIImage(named: "placeholder.png"))
                }
            } else if indexPath.row == 1 {
                cell.backgroundColor = UIColor.red
                for (index, champion) in bannedCRed!.enumerated() {
                    bannedChampionsImageViews[index].sd_setImage(with:
                        URL(string: ApiCalls.champions[champion.championId]!.images!.square.url),
                                                                 placeholderImage: UIImage(named: "placeholder.png"))
                }
            }
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath)
                as? TeamTableViewCell else { return TeamTableViewCell()}
            populateTeamCell(team: teamRed!, index: indexPath.row, cell: cell)
            return cell
        } else {
            guard let cell =  tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath)
                as? TeamTableViewCell else { return TeamTableViewCell()}
            populateTeamCell(team: teamBlue!, index: indexPath.row, cell: cell)
            return cell
        }
    }
    /**
     click event for the rows
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        guard let currentCell = tableView.cellForRow(at: indexPath)! as? TeamTableViewCell else {return}
        participantToPass = currentCell.summoner!
        performSegue(withIdentifier: "segueToPlayerDataView", sender: self)
    }
    /**
     populate the team cell with data
     
     - Parameters:
     - team: an array of participants
     - index: index of the current row
     - cell: current cell
     */
    private func populateTeamCell(team: [Participant], index: Int, cell: TeamTableViewCell) {
        cell.name.text = team[index].summonerName
        cell.icon.sd_setImage(with:
            URL(string: ApiCalls.profileIcons[team[index].profileIconId]!.profileIcon.url),
                              placeholderImage: UIImage(named: "placeholder.png"))
        cell.champion.sd_setImage(with:
            URL(string: ApiCalls.champions[team[index].championId]!.images!.square.url),
                                  placeholderImage: UIImage(named: "placeholder.png"))
        cell.summoner = team[index]
    }
}
