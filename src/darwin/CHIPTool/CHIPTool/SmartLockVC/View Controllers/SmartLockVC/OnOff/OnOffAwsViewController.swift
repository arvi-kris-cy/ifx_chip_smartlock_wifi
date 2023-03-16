//
//  OnOffAwsViewController.swift
//  SmartLock
//
//  Created by Innoflexion on 30/11/22.
//  Copyright © 2022 CHIP. All rights reserved.
//

import UIKit
import AWSIoT
import AWSMobileClientXCF

class OnOffAwsViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var onOffImageView: UIButton!
    @IBOutlet weak var lockStatusLabel: UILabel!
    @IBOutlet weak var lockDescriptionLabel: UILabel!
    @IBOutlet weak var connectingViaLabel: UILabel!
    // Battery
    @IBOutlet weak var batteryPercentageView: UIView!
    @IBOutlet weak var batteryPercentageLabel: UILabel!
    // Loading
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    // Variables
    var isAwsResonseReceived: Bool = false
    var isFirstLoad: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateOnOffUI()
        self.connectAWSSDK()
    }
    override func viewWillDisappear(_ animated: Bool) {
        handleDisconnect()
    }
    @IBAction func didTapOnBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func didTapOnLockButton(_ sender: Any) {
        if lockStatusLabel.text == "Door Unlocked" {
            publishAwsIOTStatus(isOn: false)
        } else {
            publishAwsIOTStatus(isOn: true)
        }
    }
    

    func updateLockStatus(isOn: Bool) {
        if isOn {
            onOffImageView?.setImage(UIImage.init(named: "door_opened"), for: .normal)
            lockStatusLabel?.text = "Door Unlocked"
            lockStatusLabel?.textColor = .green
            lockDescriptionLabel?.text = "Tap to lock"
        } else {
            onOffImageView?.setImage(UIImage.init(named: "door_closed"), for: .normal)
            lockStatusLabel?.text = "Door Locked"
            lockStatusLabel?.textColor = .red
            lockDescriptionLabel?.text = "Tap to unlock"
        }
    }
    
    func getInitialStatusFromAwsIot() {
        let iotDataManager = AWSIoTDataManager(forKey: AWS_IOT_DATA_MANAGER_KEY)
        iotDataManager.publishString("\"query\"", onTopic:getTopic(), qoS:.messageDeliveryAttemptedAtMostOnce)
    }
    
    func getBatteryPercentageFromAwsIot() {
        let iotDataManager = AWSIoTDataManager(forKey: AWS_IOT_DATA_MANAGER_KEY)
        iotDataManager.publishString("\"query\"", onTopic:getTopic(), qoS:.messageDeliveryAttemptedAtMostOnce)
    }
    
    func publishAwsIOTStatus(isOn: Bool) {
        if getTopic() == "SmartLock_" {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Failed to fetch device", message: "Please provision device first to communicate via cloud!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            return
        }
//        DispatchQueue.main.async {
//            self.loadingIndicator?.isHidden = false
//            self.loadingIndicator?.startAnimating()
//        }
        let iotDataManager = AWSIoTDataManager(forKey: AWS_IOT_DATA_MANAGER_KEY)
        iotDataManager.publishString(isOn ? "\"unlock\"" :
                                        "\"lock\"", onTopic:getTopic(), qoS:.messageDeliveryAttemptedAtMostOnce)
        self.updateLockStatus(isOn: isOn)
        self.isAwsResonseReceived = false
        _ = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { timer in
            if self.isAwsResonseReceived == false {
                timer.invalidate()
                self.toastMessage("It is taking longer than expected, Please wait or retry")
            }
        }
    }
    
    func subscribeAwsIOTStatus() {
        let iotDataManager = AWSIoTDataManager(forKey: AWS_IOT_DATA_MANAGER_KEY)
        iotDataManager.subscribe(toTopic: getTopic() + "/RESP", qoS: .messageDeliveryAttemptedAtMostOnce, messageCallback: {
            (payload) ->Void in
                do {
                    let json = try JSONSerialization.jsonObject(with: payload, options: .mutableContainers) as? [String:Any]
                    print(json)
                    self.isAwsResonseReceived = true
                    DispatchQueue.main.async {
                        self.loadingIndicator?.isHidden = true
                        self.loadingIndicator?.stopAnimating()
                        if self.isFirstLoad {
                            self.isFirstLoad = false
                            self.connectingViaLabel.text = "Controlling over cloud\nremote connection"
                        }
                    }
                    if let lockStatus = json?["Lock Status"] as? String {
                        DispatchQueue.main.async {
                            if lockStatus == "Lock" {
                                self.updateLockStatus(isOn: false)
                            } else {
                                self.updateLockStatus(isOn: true)
                            }
                        }
                    }
                    if let status = json?["Ack"] as? String {
                        DispatchQueue.main.async {
                            if status == "Unlock success" {
                                self.updateLockStatus(isOn: true)
                            } else {
                                self.updateLockStatus(isOn: false)
                            }
                        }
                    }
                    if let batteryPercent = json?["Batt"] as? String {
                        DispatchQueue.main.async {
                            self.batteryPercentageView?.isHidden = false
                            self.batteryPercentageLabel?.text = batteryPercent + "%"
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
//                        self.loadingIndicator?.isHidden = true
//                        self.loadingIndicator?.stopAnimating()
                    }
                    print("Something went wrong")
                }
        } )
    }
    
    func updateOnOffUI() {
       // if let name = UserDefaults.standard.string(forKey: "userNameSaved") {
            nameLabel?.text = "Hello User"
       // }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM yyyy, h:mm a"
        let date = formatter.string(from: Date())
        dateTimeLabel?.text = date
    }
    
    // MARK: - AWS IoT
    func connectAWSSDK() {
        let reachability = try? Reachability()
            self.loadingIndicator?.isHidden = false
            self.view.bringSubviewToFront(self.loadingIndicator)
            self.loadingIndicator?.startAnimating()
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:AWS_REGION,
                                                                identityPoolId:IDENTITY_POOL_ID)
        initializeControlPlane(credentialsProvider: credentialsProvider)
        initializeDataPlane(credentialsProvider: credentialsProvider)
        handleConnectViaCert()
    }
    
    func initializeControlPlane(credentialsProvider: AWSCredentialsProvider) {
        //Initialize control plane
        // Initialize the Amazon Cognito credentials provider
        let controlPlaneServiceConfiguration = AWSServiceConfiguration(region:AWS_REGION, credentialsProvider:credentialsProvider)
        
        //IoT control plane seem to operate on iot.<region>.amazonaws.com
        //Set the defaultServiceConfiguration so that when we call AWSIoTManager.default(), it will get picked up
        AWSServiceManager.default().defaultServiceConfiguration = controlPlaneServiceConfiguration
        AWSIotSharedClass.shared.iotManager = AWSIoTManager.default()
        AWSIotSharedClass.shared.iot = AWSIoT.default()
    }
    
    func initializeDataPlane(credentialsProvider: AWSCredentialsProvider) {
        //Initialize Dataplane:
        // IoT Dataplane must use your account specific IoT endpoint
        let iotEndPoint = AWSEndpoint(urlString: IOT_ENDPOINT)
        
        // Configuration for AWSIoT data plane APIs
        let iotDataConfiguration = AWSServiceConfiguration(region: AWS_REGION,
                                                           endpoint: iotEndPoint,
                                                           credentialsProvider: credentialsProvider)
        //IoTData manager operates on xxxxxxx-iot.<region>.amazonaws.com
        AWSIoTDataManager.register(with: iotDataConfiguration!, forKey: AWS_IOT_DATA_MANAGER_KEY)
        AWSIotSharedClass.shared.iotDataManager = AWSIoTDataManager(forKey: AWS_IOT_DATA_MANAGER_KEY)
    }
    
    func mqttEventCallback( _ status: AWSIoTMQTTStatus ) {
        DispatchQueue.main.async {
            print("connection status = \(status.rawValue)")

            switch status {
            case .connecting:
                print( "Connecting..." )
            case .connected:
                print( "Connected" )
                AWSIotSharedClass.shared.connected = true
                let uuid = UUID().uuidString;
                let defaults = UserDefaults.standard
                let certificateId = defaults.string( forKey: "certificateId")
                print("Using certificate:\n\(certificateId!)\n\n\nClient ID:\n\(uuid)")
                self.subscribeAwsIOTStatus()
                self.getInitialStatusFromAwsIot()
            case .disconnected:
                print( "Disconnected" )
               // self.showAlertWithBack(message: "Disconnected")
            case .connectionRefused:
                print( "Connection Refused" )
                self.showAlertWithBack(message: "Cloud Connection Refused")
            case .connectionError:
                print( "Connection Error" )
                if self.isFirstLoad {
                   // toastMessage("Could not query remote device. Check internet connectivity")
                    self.showAlertWithBack(message: "Could not query remote device. Check internet connectivity")
                } else {
                   // toastMessage("Lost internet connectivity")
                    self.showAlertWithBack(message: "Lost internet connectivity")
                }
            case .protocolError:
                print( "Protocol Error" )
                if self.isFirstLoad {
                   // toastMessage("Could not query remote device. Check internet connectivity")
                    self.showAlertWithBack(message: "Could not query remote device. Check internet connectivity")
                } else {
                   // toastMessage("Lost internet connectivity")
                    self.showAlertWithBack(message: "Lost internet connectivity")
                }
            default:
                print("unknown state: \(status.rawValue)")
                self.showAlertWithBack(message: "\(status.rawValue)")
            }
            NotificationCenter.default.post( name: Notification.Name(rawValue: "connectionStatusChanged"), object: self )
        }
    }
    
    func showAlertWithBack(message: String) {
        // Create the alert controller
        handleDisconnect()
        toastMessage(message)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5 , execute: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func handleConnectViaCert() {
        
        let defaults = UserDefaults.standard
        let certificateId = defaults.string( forKey: "certificateId")
        if (certificateId == nil) {
            DispatchQueue.main.async {
                print("No identity available, searching bundle...")
            }
            let certificateIdInBundle = searchForExistingCertificateIdInBundle()
            
            if (certificateIdInBundle == nil) {
                DispatchQueue.main.async {
                    print("No identity found in bundle, creating one...")
                }
                createCertificateIdAndStoreinNSUserDefaults(onSuccess: {generatedCertificateId in
                    let uuid = UUID().uuidString
                    print("Using certificate: \(generatedCertificateId)")
                    AWSIotSharedClass.shared.iotDataManager.connect( withClientId: uuid, cleanSession:true, certificateId:generatedCertificateId, statusCallback: self.mqttEventCallback)
                }, onFailure: {error in
                    print("Received error: \(error)")
                })
            }
        } else {
            let uuid = UUID().uuidString;
            // Connect to the AWS IoT data plane service w/ certificate
            AWSIotSharedClass.shared.iotDataManager.connect( withClientId: uuid, cleanSession:true, certificateId:certificateId!, statusCallback: self.mqttEventCallback)
        }
    }

    func searchForExistingCertificateIdInBundle() -> String? {
        let defaults = UserDefaults.standard
        // No certificate ID has been stored in the user defaults; check to see if any .p12 files
        // exist in the bundle.
        let myBundle = Bundle.main
        let myImages = myBundle.paths(forResourcesOfType: "p12" as String, inDirectory:nil)
        let uuid = UUID().uuidString

        guard let certId = myImages.first else {
            let certificateId = defaults.string(forKey: "certificateId")
            return certificateId
        }
        
        // A PKCS12 file may exist in the bundle.  Attempt to load the first one
        // into the keychain (the others are ignored), and set the certificate ID in the
        // user defaults as the filename.  If the PKCS12 file requires a passphrase,
        // you'll need to provide that here; this code is written to expect that the
        // PKCS12 file will not have a passphrase.
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: certId)) else {
            print("[ERROR] Found PKCS12 File in bundle, but unable to use it")
            let certificateId = defaults.string( forKey: "certificateId")
            return certificateId
        }
        
        DispatchQueue.main.async {
            print("found identity \(certId), importing...")
        }
        if AWSIoTManager.importIdentity( fromPKCS12Data: data, passPhrase:"", certificateId:certId) {
            // Set the certificate ID and ARN values to indicate that we have imported
            // our identity from the PKCS12 file in the bundle.
            defaults.set(certId, forKey:"certificateId")
            defaults.set("from-bundle", forKey:"certificateArn")
            DispatchQueue.main.async {
                print("Using certificate: \(certId))")
                AWSIotSharedClass.shared.iotDataManager.connect( withClientId: uuid,
                                             cleanSession:true,
                                             certificateId:certId,
                                             statusCallback: self.mqttEventCallback)
            }
        }
        
        let certificateId = defaults.string( forKey: "certificateId")
        return certificateId
    }
    
    func createCertificateIdAndStoreinNSUserDefaults(onSuccess:  @escaping (String)->Void,
                                                     onFailure: @escaping (Error) -> Void) {
        let defaults = UserDefaults.standard
        // Now create and store the certificate ID in NSUserDefaults
        let csrDictionary = [ "commonName": CertificateSigningRequestCommonName,
                              "countryName": CertificateSigningRequestCountryName,
                              "organizationName": CertificateSigningRequestOrganizationName,
                              "organizationalUnitName": CertificateSigningRequestOrganizationalUnitName]
        
        AWSIotSharedClass.shared.iotManager.createKeysAndCertificate(fromCsr: csrDictionary) { (response) -> Void in
            guard let response = response else {
                DispatchQueue.main.async {
                    print("Unable to create keys and/or certificate, check values in Constants.swift")
                }
                onFailure(NSError(domain: "No response on iotManager.createKeysAndCertificate", code: -2, userInfo: nil))
                return
            }
            defaults.set(response.certificateId, forKey:"certificateId")
            defaults.set(response.certificateArn, forKey:"certificateArn")
            let certificateId = response.certificateId
            print("response: [\(String(describing: response))]")
            
            let attachPrincipalPolicyRequest = AWSIoTAttachPrincipalPolicyRequest()
            attachPrincipalPolicyRequest?.policyName = POLICY_NAME
            attachPrincipalPolicyRequest?.principal = response.certificateArn
            
            // Attach the policy to the certificate
            AWSIotSharedClass.shared.iot.attachPrincipalPolicy(attachPrincipalPolicyRequest!).continueWith (block: { (task) -> AnyObject? in
                if let error = task.error {
                    print("Failed: [\(error)]")
                    onFailure(error)
                } else  {
                    print("result: [\(String(describing: task.result))]")
                    DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                        if let certificateId = certificateId {
                            onSuccess(certificateId)
                        } else {
                            onFailure(NSError(domain: "Unable to generate certificate id", code: -1, userInfo: nil))
                        }
                    })
                }
                return nil
            })
        }
    }

    func handleDisconnect() {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            AWSIotSharedClass.shared.iotDataManager.disconnect();
            DispatchQueue.main.async {
                AWSIotSharedClass.shared.connected = false
            }
        }
    }
}


class AWSIotSharedClass {
    static let shared = AWSIotSharedClass()
    private init() {}
     var iotDataManager: AWSIoTDataManager!
     var iotManager: AWSIoTManager!
     var iot: AWSIoT!
     var connected = false

}
