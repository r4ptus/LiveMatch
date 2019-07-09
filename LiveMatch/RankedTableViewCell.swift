//
//  RankedTableViewCell.swift
//  LiveMatch
//
//  Created by ema on 08.07.19.
//  Copyright © 2019 raptus. All rights reserved.
//

import UIKit

class RankedTableViewCell: UITableViewCell {
    @IBOutlet var rankedImage: UIImageView!
    @IBOutlet var tier: UILabel!
    @IBOutlet var leaguePoints: UILabel!
    @IBOutlet var wins: UILabel!
    @IBOutlet var loses: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
