//
//  SetupKeyPinViewController.swift
//  SmartLock
//
//  Created by User on 01/08/22.
//  Copyright © 2022 CHIP. All rights reserved.
//

import UIKit
import AWSIoT

class SetupKeyPinViewController: UIViewController {

    @IBOutlet weak var enterKeyTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        connectAWSSDK()
        // Do any additional setup after loading the view.
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        handleDisconnect()
    }
    
    @IBAction func keyPinSubmitButton(_ sender: Any) {
        self.view.endEditing(true)
        if let text = enterKeyTextfield.text, text.count == 6 {
            let iotDataManager = AWSIoTDataManager(forKey: AWS_IOT_DATA_MANAGER_KEY)
            iotDataManager.publishString("\"PIN \(text)\"", onTopic:getTopic(), qoS:.messageDeliveryAttemptedAtMostOnce)
            self.toastMessage("Updating new PIN information…", duration: 2)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.toastMessage("Update complete")
            })
        } else {
            self.toastMessage("Pin should be of 6 numbers")
        }
    }
    
    @IBAction func sideMenuButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - AWS IoT
    func sendQueryAfterSuccefullConnection() {
        let iotDataManager = AWSIoTDataManager(forKey: AWS_IOT_DATA_MANAGER_KEY)
        iotDataManager.publishString("\"query\"", onTopic:getTopic(), qoS:.messageDeliveryAttemptedAtMostOnce)
    }
    
    func connectAWSSDK() {
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
                self.sendQueryAfterSuccefullConnection()
            case .disconnected:
                print( "Disconnected" )
            case .connectionRefused:
                print( "Connection Refused" )
            case .connectionError:
                print( "Connection Error" )
            case .protocolError:
                print( "Protocol Error" )
            default:
                print("unknown state: \(status.rawValue)")
            }
            NotificationCenter.default.post( name: Notification.Name(rawValue: "connectionStatusChanged"), object: self )
        }
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
