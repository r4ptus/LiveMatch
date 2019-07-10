//
//  BannedChampionsTableViewCell.swift
//  LiveMatch
//
//  Created by ema on 06.07.19.
//  Copyright © 2019 raptus. All rights reserved.
//

import UIKit
///TableViewCell for the banned champions
///has five imageViews
class BannedChampionsTableViewCell: UITableViewCell {
    @IBOutlet var champion1: UIImageView!
    @IBOutlet var champion2: UIImageView!
    @IBOutlet var champion3: UIImageView!
    @IBOutlet var champion4: UIImageView!
    @IBOutlet var champion5: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
