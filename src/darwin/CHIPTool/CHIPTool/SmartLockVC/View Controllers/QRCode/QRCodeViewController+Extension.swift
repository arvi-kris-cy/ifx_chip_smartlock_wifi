//
//  QRCodeViewController+Extension.swift
//  CHIPTool
//
//  Created by Chandra Sekhar on 12/05/22.
//  Copyright © 2022 CHIP. All rights reserved.
//

import Foundation

@objc extension QRCodeViewController {
    
    @objc func updateUILayout() {
        
        deviceAddressTF?.layer.cornerRadius = 10
        deviceAddressTF?.layer.borderWidth = 1
        deviceAddressTF?.layer.borderColor = UIColor.lightGray.cgColor
        deviceAddressTF?.layer.masksToBounds = true
        deviceAddressTF?.setLeftPaddingPoints(10)
        
        submitButton?.layer.cornerRadius = 4
    }
    
    @objc func openSideMenu() {
        revealViewController()?.revealSideMenu()
    }
    
}
