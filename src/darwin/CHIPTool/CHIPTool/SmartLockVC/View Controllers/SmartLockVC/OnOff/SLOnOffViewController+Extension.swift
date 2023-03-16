//
//  SLOnOffViewController+Extension.swift
//  CHIPTool
//
//  Created by Chandra Sekhar on 17/05/22.
//  Copyright © 2022 CHIP. All rights reserved.
//

import Foundation
import AWSIoT
import AWSMobileClientXCF

@objc extension SLOnOffViewController {
    
    func updateLockStatus(isOn: Bool) {
        DispatchQueue.main.async {
            if isOn {
                self.onOffImageView?.setImage(UIImage.init(named: "door_opened"), for: .normal)
                self.lockStatusLabel?.text = "Door Unlocked"
                self.lockStatusLabel?.textColor = .green
                self.lockDescriptionLabel?.text = "Tap to lock"
            } else {
                self.onOffImageView?.setImage(UIImage.init(named: "door_closed"), for: .normal)
                self.lockStatusLabel?.text = "Door Locked"
                self.lockStatusLabel?.textColor = .red
                self.lockDescriptionLabel?.text = "Tap to unlock"
            }
        }
    }
    
    
    func updateOnOffUI() {
        // if let name = UserDefaults.standard.string(forKey: "userNameSaved") {
        nameLabel?.text = "Hello User"
        // }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM yyyy, h:mm a"
        let date = formatter.string(from: Date())
        dateTimeLabel?.text = date
    }
    
}
