//
//  ViewDeviceViewController.swift
//  SmartLock
//
//  Created by User on 01/08/22.
//  Copyright © 2022 CHIP. All rights reserved.
//

import UIKit

class ViewDeviceViewController: UIViewController {

    
    @IBOutlet weak var deviceIdLabel: UILabel!
    @IBOutlet weak var systemIdLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var deviceTypeLabel: UILabel!
    
    @IBOutlet weak var deviceNameLabel: UILabel!
    
    
     override func viewDidLoad() {
         super.viewDidLoad()

         // Do any additional setup after loading the view.
     }
    
    
    
    @IBAction func configureDeviceButton(_ sender: Any) {
       // ProvisionViewController
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProvisionViewController") as! ProvisionViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func blackListTokenButton(_ sender: Any) {
        
    }
    
    @IBAction func backButtonTap(_ sender: Any) { 
        self.navigationController?.popViewController(animated: true)
    }
    

}
