//
//  ConfigIotTableViewCell.swift
//  SmartLock
//
//  Created by User on 01/08/22.
//  Copyright © 2022 CHIP. All rights reserved.
//

import UIKit

class ConfigIotTableViewCell: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
