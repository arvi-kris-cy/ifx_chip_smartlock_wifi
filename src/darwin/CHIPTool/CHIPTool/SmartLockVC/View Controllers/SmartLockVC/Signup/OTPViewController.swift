//
//  OTPViewController.swift
//  CHIPTool
//
//  Created by Chandra Sekhar on 30/05/22.
//  Copyright © 2022 CHIP. All rights reserved.
//

import UIKit
import Amplify
import AWSCognitoAuthPlugin

class OTPViewController: UIViewController {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var otpTf: UITextField!
    @IBOutlet weak var proceedButton: UIButton!
    var userName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgView?.layer.borderWidth = 1
        bgView?.layer.borderColor = UIColor.systemGray4.cgColor
        
        otpTf?.layer.cornerRadius = 10
        otpTf?.layer.borderWidth = 1
        otpTf?.layer.borderColor = UIColor.lightGray.cgColor
        otpTf?.layer.masksToBounds = true
        otpTf?.setLeftPaddingPoints(10)
        
        proceedButton?.layer.cornerRadius = 10
        proceedButton?.layer.masksToBounds = true
        
    }
    
    @IBAction func didTapOnProceedButton(_ sender: Any) {
        if otpTf.text == "" {
            let alert = UIAlertController(title: "Alert!", message: "Please enter OTP", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.confirmSignUp(for: userName!, with: otpTf.text!)
        }
        
    }
    
    func confirmSignUp(for username: String, with confirmationCode: String) {
        Amplify.Auth.confirmSignUp(for: username, confirmationCode: confirmationCode) { result in
            switch result {
            case .success:
                print("Confirm signUp succeeded")
                DispatchQueue.main.async {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            case .failure(let error):
                print("An error occurred while confirming sign up \(error)")
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error!", message: "An error occurred while confirming sign up \(error)", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    @IBAction func didTapOnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
