

import Foundation
import AWSCore

//WARNING: To run this sample correctly, you must set the following constants.

let CertificateSigningRequestCommonName = "SmartLock_iOS"
let CertificateSigningRequestCountryName = "India"
let CertificateSigningRequestOrganizationName = "Innoflexion"
let CertificateSigningRequestOrganizationalUnitName = "Innoflexion-In"

let POLICY_NAME = "SmartLock_Custom_policy_iOS"

// This is the endpoint in your AWS IoT console. eg: https://xxxxxxxxxx.iot.<region>.amazonaws.com
let AWS_REGION = AWSRegionType.USEast2

//For both connecting over websockets and cert, IOT_ENDPOINT should look like
//https://xxxxxxx-ats.iot.REGION.amazonaws.com
let IOT_ENDPOINT = "https://a3122exvv01xdw-ats.iot.us-east-2.amazonaws.com"
let IDENTITY_POOL_ID = "us-east-2:15b12349-0696-446f-bcad-335f567fdec0"

//Used as keys to look up a reference of each manager
let AWS_IOT_DATA_MANAGER_KEY = "SmartLockIotDataManager"
let AWS_IOT_MANAGER_KEY = "SmartLockIotManager"

func getTopic() -> String {
    let discriminator = UserDefaults.standard.value(forKey: "discriminatorSaved")
   // return "SmartLock_3848"
    return "\(discriminator ?? "")"
}

func saveTopic(topic: String) {
    UserDefaults.standard.setValue(topic, forKey: "discriminatorSaved")
}

func saveMininterval(seconds: String) {
    UserDefaults.standard.setValue(seconds, forKey: "minIntervalSeconds")
}

func saveMaxinterval(seconds: String) {
    UserDefaults.standard.setValue(seconds, forKey: "maxIntervalSeconds")
}

func getMininterval() -> String {
    let discriminator = UserDefaults.standard.value(forKey: "minIntervalSeconds")
   // return "SmartLock_3848"
    return "\(discriminator ?? "1")"
}

func getMaxinterval() -> String {
    let discriminator = UserDefaults.standard.value(forKey: "maxIntervalSeconds")
   // return "SmartLock_3848"
    return "\(discriminator ?? "1")"
}
