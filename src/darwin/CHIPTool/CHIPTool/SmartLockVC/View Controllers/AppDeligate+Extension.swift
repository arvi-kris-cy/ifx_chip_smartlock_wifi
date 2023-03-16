//
//  AppDeligate+Extension.swift
//  CHIPTool
//
//  Created by Chandra Sekhar on 27/05/22.
//  Copyright © 2022 CHIP. All rights reserved.
//

import Foundation
import Amplify
//import AWSCognitoAuthPlugin

@objc extension AppDelegate {
   
    func configureAmplify() {
//        do {
//            try Amplify.add(plugin: AWSCognitoAuthPlugin())
//            try Amplify.configure()
//            print("Amplify configured with auth plugin")
//        } catch {
//            print("Failed to initialize Amplify with \(error)")
//        }
        
    }
    
}

@objc public extension UIViewController {

    @objc func toastMessage(_ message: String, duration: Float = 2) {
        let messageLbl = UILabel()
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.keyWindow else {return}
            messageLbl.text = message
            messageLbl.textAlignment = .center
            messageLbl.font = UIFont.systemFont(ofSize: 12)
            messageLbl.textColor = .white
            messageLbl.backgroundColor = UIColor(white: 0, alpha: 0.8)
            
            let textSize:CGSize = messageLbl.intrinsicContentSize
            let labelWidth = min(textSize.width, window.frame.width - 40)
            
            messageLbl.frame = CGRect(x: 20, y: window.frame.height - 120, width: labelWidth + 30, height: textSize.height + 20)
            messageLbl.center.x = window.center.x
            messageLbl.layer.cornerRadius = messageLbl.frame.height/2
            messageLbl.layer.masksToBounds = true
            window.addSubview(messageLbl)
        }
        let dispatchAfter = DispatchTimeInterval.seconds(Int(duration))

        DispatchQueue.main.asyncAfter(deadline: .now() + dispatchAfter) {
            
            UIView.animate(withDuration: 1, animations: {
                messageLbl.alpha = 0
            }) { (_) in
                messageLbl.removeFromSuperview()
            }
        }
    }}
