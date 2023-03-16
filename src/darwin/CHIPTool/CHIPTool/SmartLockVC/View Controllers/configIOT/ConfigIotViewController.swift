//
//  ConfigIotViewController.swift
//  SmartLock
//
//  Created by User on 01/08/22.
//  Copyright © 2022 CHIP. All rights reserved.
//

import UIKit

class ConfigIotViewController: UIViewController {
    @IBOutlet weak var devicesListTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        revealViewController()?.gestureEnabled = false
        devicesListTable.dataSource = self
        devicesListTable.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addDeviceButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddDeviceViewController") as! AddDeviceViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func sideMenuButton(_ sender: Any) {
        revealViewController()?.revealSideMenu()
    }

}

extension ConfigIotViewController: UITableViewDataSource, UITableViewDelegate {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConfigIotTableViewCell") as! ConfigIotTableViewCell

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewDeviceViewController") as! ViewDeviceViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

