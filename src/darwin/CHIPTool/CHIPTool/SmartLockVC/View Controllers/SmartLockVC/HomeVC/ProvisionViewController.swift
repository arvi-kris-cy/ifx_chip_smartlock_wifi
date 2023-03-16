//
//  ProvisionViewController.swift
//  CHIPTool
//
//  Created by Chandra Sekhar on 12/05/22.
//  Copyright © 2022 CHIP. All rights reserved.
//

import UIKit
import Amplify
//import AWSCognitoAuthPlugin
import AWSCore

class ProvisionViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var provisionChipDeviceWithWifiButton: UIButton!
    @IBOutlet weak var lockOnOffButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        provisionChipDeviceWithWifiButton?.layer.cornerRadius = 4
        provisionChipDeviceWithWifiButton?.layer.masksToBounds = true
        lockOnOffButton?.layer.cornerRadius = 4
        lockOnOffButton?.layer.masksToBounds = true
        loadData()
        revealViewController()?.gestureEnabled = false

        
//        let credentialsProvider = AWSCognitoCredentialsProvider(
//            regionType: .USEast1,
//            identityPoolId: "us-east-1:6d9e41c4-d73f-4f77-8ecf-64ac1ecd2229")
//        let configuration = AWSServiceConfiguration(
//            region: .USEast1,
//            credentialsProvider: credentialsProvider)
//        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
      //  awsServiceCalls()
    }
    
//    func awsServiceCalls() {
//        let dynamoDB = AWSDynamoDB.default()
//        let listTableInput = AWSDynamoDBListTablesInput()
//        dynamoDB.listTables(listTableInput!).continueWith { (task:AWSTask<AWSDynamoDBListTablesOutput>) -> Any? in
//            if let error = task.error as? NSError {
//                print("Error occurred: \(error)")
//                return nil
//            }
//            let listTablesOutput = task.result
//            for tableName in listTablesOutput!.tableNames! {
//                print("\(tableName)")
//            }
//            return nil
//        }
//    }
    
    private func loadData() {
       // if let name = UserDefaults.standard.string(forKey: "userNameSaved") {
            nameLabel.text = "Hello User"
       // }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM yyyy, h:mm a"
        let date = formatter.string(from: Date())
        dateTimeLabel.text = date
    }
    
    @IBAction func wifiButtonTapped(_ sender: Any) {
        
//                let controller = QRCodeViewController()
//                self.navigationController?.pushViewController(controller, animated: true)

        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = (storyboard.instantiateViewController(identifier: "QRCodeViewController") as! QRCodeViewController)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func lockOnOffButton(_ sender: Any) {
        
//        let controller = OnOffViewController()
//        self.navigationController?.pushViewController(controller, animated: true)
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = (storyboard.instantiateViewController(identifier: "SLOnOffViewController") as! SLOnOffViewController)
        vc.isFromHomeScreen = true
        vc.isRemoteAccessUsingAWSIotEnabled = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backButton(_ sender: Any) {
        revealViewController()?.revealSideMenu()

      //  self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        signOutGlobally()
    }
    
    func signOutGlobally() {
//        Amplify.Auth.signOut(options: .init(globalSignOut: true)) { result in
//            switch result {
//            case .success:
//                print("Successfully signed out")
//                DispatchQueue.main.async {
//                    self.navigationController?.popToRootViewController(animated: true)
//                }
//            case .failure(let error):
//                print("Sign out failed with error \(error)")
//                DispatchQueue.main.async {
//                    let alert = UIAlertController(title: "LogOut Failed", message: "Sign out failed with error \(error)", preferredStyle: UIAlertController.Style.alert)
//                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
//                }
//            }
//        }
    }
}
