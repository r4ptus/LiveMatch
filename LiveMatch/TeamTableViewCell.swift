//
//  TeamTableViewCell.swift
//  LiveMatch
//
//  Created by ema on 06.07.19.
//  Copyright © 2019 raptus. All rights reserved.
//

import UIKit
import LeagueAPI

class TeamTableViewCell: UITableViewCell {
    @IBOutlet var champion: UIImageView!
    @IBOutlet var icon: UIImageView!
    @IBOutlet var name: UILabel!
    public var summoner: Participant?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
