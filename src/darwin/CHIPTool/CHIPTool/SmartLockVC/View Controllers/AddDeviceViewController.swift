//
//  AddDeviceViewController.swift
//  SmartLock
//
//  Created by User on 01/08/22.
//  Copyright © 2022 CHIP. All rights reserved.
//

import UIKit

class AddDeviceViewController: UIViewController {

    @IBOutlet weak var deviceNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        deviceNameTextField.text = getTopic()
        // Do any additional setup after loading the view.
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addNewDeviceButtonTapped(_ sender: Any) {
        self.view.endEditing(true)
        if let topic = deviceNameTextField.text {
            saveTopic(topic: topic)
            self.toastMessage("Saved configuration successfully")
        } else {
            self.toastMessage("Please enter topic")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
