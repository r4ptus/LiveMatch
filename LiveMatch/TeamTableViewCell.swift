//
//  TeamTableViewCell.swift
//  LiveMatch
//
//  Created by ema on 06.07.19.
//  Copyright © 2019 raptus. All rights reserved.
//

import UIKit

class TeamTableViewCell: UITableViewCell {
    @IBOutlet var champion: UIImageView!
    @IBOutlet var icon: UIImageView!
    @IBOutlet var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
