//
//  RuneTableViewCell.swift
//  LiveMatch
//
//  Created by ema on 08.07.19.
//  Copyright © 2019 raptus. All rights reserved.
//

import UIKit
///TableVIewCell for runes
///each cell has an imageview and a label
class RuneTableViewCell: UITableViewCell {
    @IBOutlet var runeImage: UIImageView!
    @IBOutlet var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
