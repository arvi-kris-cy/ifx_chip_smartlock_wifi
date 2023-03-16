//
//  RootViewControllerExtension.swift
//  CHIPTool
//
//  Created by Chandra Sekhar on 11/05/22.
//  Copyright © 2022 CHIP. All rights reserved.
//

import Foundation
import Amplify
//import AWSCognitoAuthPlugin
//import SQLite

@objc extension RootViewController {
    
    func updateUI() {
        self.headerBackgroundView?.layer.cornerRadius = 20
        self.headerBackgroundView?.layer.masksToBounds = true
        loginBackgroundView?.layer.borderWidth = 1
        loginBackgroundView?.layer.borderColor = UIColor.systemGray4.cgColor
        
        userNameTF?.layer.cornerRadius = 10
        userNameTF?.layer.borderWidth = 1
        userNameTF?.layer.borderColor = UIColor.lightGray.cgColor
        userNameTF?.layer.masksToBounds = true
        userNameTF?.setLeftPaddingPoints(10)
        
        passwordTf?.layer.cornerRadius = 10
        passwordTf?.layer.borderWidth = 1
        passwordTf?.layer.borderColor = UIColor.lightGray.cgColor
        passwordTf?.layer.masksToBounds = true
        passwordTf?.setLeftPaddingPoints(10)
        
        proceedButton?.layer.cornerRadius = 10
        proceedButton?.layer.masksToBounds = true
        self.signOutGlobally()
    }
    
    func saveName(name: String) {
        UserDefaults.standard.set(name, forKey: "userNameSaved")
    }
    
    func signIn(username: String, password: String) {
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = (storyboard.instantiateViewController(identifier: "MainViewController") as! MainViewController)
            self.navigationController?.pushViewController(vc, animated: true)
        return
       // self.signOutGlobally()
        /*
        Amplify.Auth.signIn(username: username, password: password) { result in
            switch result {
            case .success:
                do {
                    let signinResult = try result.get()
                    switch signinResult.nextStep {
                    case .confirmSignInWithSMSMFACode(let deliveryDetails, let info):
                        print("SMS code send to \(deliveryDetails.destination)")
                        print("Additional info \(info)")
                        
                        // Prompt the user to enter the SMSMFA code they received
                        // Then invoke `confirmSignIn` api with the code
                        
                    case .confirmSignInWithCustomChallenge(let info):
                        print("Custom challenge, additional info \(info)")
                        
                        // Prompt the user to enter custom challenge answer
                        // Then invoke `confirmSignIn` api with the answer
                        
                    case .confirmSignInWithNewPassword(let info):
                        print("New password additional info \(info)")
                        
                        // Prompt the user to enter a new password
                        // Then invoke `confirmSignIn` api with new password
                        
                    case .resetPassword(let info):
                        print("Reset password additional info \(info)")
                        
                        // User needs to reset their password.
                        // Invoke `resetPassword` api to start the reset password
                        // flow, and once reset password flow completes, invoke
                        // `signIn` api to trigger signin flow again.
                        
                    case .confirmSignUp(let info):
                        print("Confirm signup additional info \(info)")
                        // User was not confirmed during the signup process.
                        // Invoke `confirmSignUp` api to confirm the user if
                        // they have the confirmation code. If they do not have the
                        // confirmation code, invoke `resendSignUpCode` to send the
                        // code again.
                        // After the user is confirmed, invoke the `signIn` api again.
                        Amplify.Auth.resendSignUpCode(for: self.userNameTF.text!) { result in
                            switch result {
                            case .success:
                                DispatchQueue.main.async {
                                    let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                    let vc = (storyboard.instantiateViewController(identifier: "OTPViewController") as! OTPViewController)
                                    vc.userName = self.userNameTF.text!
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            case .failure(let error):
                                DispatchQueue.main.async {
                                    let alert = UIAlertController(title: "Login Failed", message: "Login in failed \(error)", preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                        }
                    case .done:
                        // Use has successfully signed in to the app
                        print("Signin complete")
                        DispatchQueue.main.async {
                            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = (storyboard.instantiateViewController(identifier: "ProvisionViewController") as! ProvisionViewController)
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                } catch {
                    print ("Sign in failed \(error)")
                }
                
            case .failure(let error):
                print("Sign in failed \(error)")
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Login Failed", message: "Login in failed \(error)", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } */
        
    }
    
    func signOutGlobally() {
//        Amplify.Auth.signOut(options: .init(globalSignOut: true)) { result in
//            switch result {
//            case .success:
//                print("Successfully signed out")
//            case .failure(let error):
//                print("Sign out failed with error \(error)")
//            }
//        }
    }
}
