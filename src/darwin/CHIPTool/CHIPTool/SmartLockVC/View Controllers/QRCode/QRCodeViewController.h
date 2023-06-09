/**
 *
 *    Copyright (c) 2020 Project CHIP Authors
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

#import <AVFoundation/AVFoundation.h>
#import <Matter/Matter.h>
#import <CoreNFC/CoreNFC.h>
#import <UIKit/UIKit.h>
@class QRCodeViewController;

@interface QRCodeViewController
    : UIViewController <AVCaptureMetadataOutputObjectsDelegate, MTRDevicePairingDelegate, NFCNDEFReaderSessionDelegate>
@property (weak, nonatomic) IBOutlet UITextField *deviceAddressTF;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIView *qrCodeViewPreview;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *sideMenuButton;



@end
