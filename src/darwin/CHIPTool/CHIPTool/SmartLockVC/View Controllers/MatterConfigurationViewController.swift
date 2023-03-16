//
//  MatterConfigurationViewController.swift
//  SmartLock
//
//  Created by Innoflexion on 28/11/22.
//  Copyright © 2022 CHIP. All rights reserved.
//

import UIKit

class MatterConfigurationViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var timeIntervalLabel: UILabel!
    @IBOutlet weak var minTimeIntervalTextField: UITextField!
    @IBOutlet weak var maxTimeIntervalTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        minTimeIntervalTextField.delegate = self
        maxTimeIntervalTextField.delegate = self
        timeIntervalLabel.text = "Current Intervals min: \(getMininterval()) max: \(getMaxinterval())"
        // Do any additional setup after loading the view.
    }
    @IBAction func didTapOnBackButton(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapOnSubmitButton(_ sender: Any) {
        self.view.endEditing(true)
        if minTimeIntervalTextField.text?.isEmpty ?? true {
            toastMessage("Please enter minimum time interval") // min is empty
            return
        }
        if maxTimeIntervalTextField.text?.isEmpty ?? true {
            toastMessage("Please enter maximum time interval") // max is empty
            return
        }
        if let minInter = Int(minTimeIntervalTextField.text ?? ""), let maxInter = Int(maxTimeIntervalTextField.text ?? "") {
            if minInter > 60 || maxInter > 60 {
                toastMessage("Interval shouldn't be more than 60 sec") // min or max is greater than 60
                return
            }
            if minInter > maxInter {
                toastMessage("minimum interval shouldn't be more than maximum interval") // min is greater than max
                return
            }
        }
        saveMininterval(seconds: minTimeIntervalTextField.text ?? "1")
        saveMaxinterval(seconds: maxTimeIntervalTextField.text ?? "1")
        self.toastMessage("Saved the configuration successfully", duration: 2)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.navigationController?.popViewController(animated: true)
//        }
    }
    
    //MARK - UITextField Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn:"+0123456789 ")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
