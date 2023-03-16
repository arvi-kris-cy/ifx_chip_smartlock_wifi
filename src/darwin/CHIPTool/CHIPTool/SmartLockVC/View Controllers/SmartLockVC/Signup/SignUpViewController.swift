//
//  SignUpViewController.swift
//  CHIPTool
//
//  Created by Chandra Sekhar on 30/05/22.
//  Copyright © 2022 CHIP. All rights reserved.
//

import UIKit
import Amplify
//import AWSCognitoAuthPlugin

class SignUpViewController: UIViewController {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var proceedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bgView?.layer.borderWidth = 1
        bgView?.layer.borderColor = UIColor.systemGray4.cgColor
        
        emailTf?.layer.cornerRadius = 10
        emailTf?.layer.borderWidth = 1
        emailTf?.layer.borderColor = UIColor.lightGray.cgColor
        emailTf?.layer.masksToBounds = true
        emailTf?.setLeftPaddingPoints(10)
        
        passwordTf?.layer.cornerRadius = 10
        passwordTf?.layer.borderWidth = 1
        passwordTf?.layer.borderColor = UIColor.lightGray.cgColor
        passwordTf?.layer.masksToBounds = true
        passwordTf?.setLeftPaddingPoints(10)
        
        proceedButton?.layer.cornerRadius = 10
        proceedButton?.layer.masksToBounds = true

    }
    
    @IBAction func didTapOnproceedButton(_ sender: Any) {
        if emailTf.text == "" || passwordTf.text == "" {
            let alert = UIAlertController(title: "Alert", message: "All Fields are mandatory", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.signUp(username: emailTf.text!, password: passwordTf.text!, email: emailTf.text!)
        }
    }
    
    
    func signUp(username: String, password: String, email: String) {
        let userAttributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        Amplify.Auth.signUp(username: username, password: password, options: options) { result in
            switch result {
            case .success(let signUpResult):
                if case let .confirmUser(deliveryDetails, _) = signUpResult.nextStep {
                    print("Delivery details \(String(describing: deliveryDetails))")
                    DispatchQueue.main.async {
                        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = (storyboard.instantiateViewController(identifier: "OTPViewController") as! OTPViewController)
                        vc.userName = self.emailTf.text!
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    print("SignUp Complete")
                    self.navigationController?.popViewController(animated: true)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("An error occurred while registering a user \(error)")
                    let alert = UIAlertController(title: "Alert", message: "An error occurred while registering a user \(error)", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func didTaponBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
