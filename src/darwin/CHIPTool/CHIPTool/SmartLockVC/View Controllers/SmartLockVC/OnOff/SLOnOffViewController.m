//
//  SLOnOffViewController.m
//  CHIPTool
//
//  Created by Chandra Sekhar on 17/05/22.
//  Copyright © 2022 CHIP. All rights reserved.
//

#import "SLOnOffViewController.h"
#import "CHIPUIViewUtils.h"
#import "DefaultsUtils.h"
#import "DeviceSelector.h"
#import <Matter/Matter.h>
#import "SmartLock-Swift.h"

@interface SLOnOffViewController ()

@property (nonatomic, strong) DeviceSelector * deviceSelector;

@end

@implementation SLOnOffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isFirstLoad = YES;
    [self updateOnOffUI];
    _deviceSelector = [DeviceSelector new];
    UILabel * deviceIDLabel = [UILabel new];
    deviceIDLabel.text = @"Device ID:";
    UIView * deviceIDView = [CHIPUIViewUtils viewWithLabel:deviceIDLabel textField:_deviceSelector];
    [_loadingIndicator setHidden:YES];
    [_batteryPercentageView setHidden:YES];
    NSLog(@"%@", _deviceSelector.text);
        if ([_deviceSelector.text isEqualToString:@""]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self toastMessage:@"Cant get device id, please pair again" duration:2];
                [self turnBackToHomeViewController];
            });
        } else {
            // Start
            [self subscribeToChip];
            // End
           // [self didTapOnOn];
        }
}

- (IBAction)didTapOnBackButton:(id)sender {
//    if (_isFromHomeScreen) {
//        [self.navigationController popViewControllerAnimated:true];
//    } else {
        [self turnBackToHomeViewController];
  //  }
}

/// turn back to home view controller
- (void)turnBackToHomeViewController {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        //Do not forget to import AnOldViewController.h
        if ([controller isKindOfClass:[MainViewController class]]) {
            [self.navigationController popToViewController:controller
                                                  animated:YES];
            return;
        }
    }
}

- (IBAction)didTapOnLockButton:(id)sender {
    if ([_lockStatusLabel.text isEqualToString:@"Door Unlocked"]) {
        [self didTapOnOff];
    } else {
        [self didTapOnOn];
    }
}

/// subscribe to Chip device
-(void)subscribeToChip {
    //dispatch_async(dispatch_get_main_queue(), ^{
        [[self loadingIndicator] startAnimating];
        [self loadingIndicator].hidden = NO;
    //});
    [_deviceSelector forSelectedDevices:^(uint64_t deviceId) {
        if (MTRGetConnectedDeviceWithID(deviceId, ^(MTRBaseDevice * _Nullable chipDevice, NSError * _Nullable error) {
            if (chipDevice) {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                NSString * min = [defaults valueForKey:@"minIntervalSeconds"];
                NSNumberFormatter *minN = [[NSNumberFormatter alloc] init];
                minN.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *minNumber = [minN numberFromString:min];
                if (minNumber == nil) {
                    minNumber = @1;
                }
                
                NSString * max = [defaults valueForKey:@"maxIntervalSeconds"];
                NSNumberFormatter *maxN = [[NSNumberFormatter alloc] init];
                maxN.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *maxNumber = [maxN numberFromString:max];
                if (maxNumber == nil) {
                    maxNumber = @1;
                }
                
                MTRBaseClusterDoorLock * chip = [[MTRBaseClusterDoorLock alloc] initWithDevice:chipDevice
                                                                                      endpoint:1
                                                               queue:dispatch_get_main_queue()];
                
                //MARK: -
                __auto_type * params = [[MTRSubscribeParams alloc] initWithMinInterval:@1
                                                                           maxInterval:@1];
               // params.keepPreviousSubscriptions = [NSNumber numberWithBool:YES];
                [chip subscribeAttributeLockStateWithParams:params
                                     subscriptionEstablished:^{
                    NSLog(@"New subscription was established");
                }
                                               reportHandler:^(NSNumber * _Nullable value, NSError * _Nullable error) {
                    NSLog(@"New subscriber received a report: %@, error: %@", value, error);
                    if (value == nil) {
                        [self toastMessage:error.localizedDescription duration:2];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                            [self turnBackToHomeViewController];
                        });
                        return;
                    }
                    //dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopLoadingIndicator];
                    //});
                    if (self.isFirstLoad == YES) {
                        self.isFirstLoad = NO;
                        self.connectingViaLabel.text = @"Controlling over local\nmatter network";
                    }
                    if (value.intValue == 1) {
                        NSLog(@"------ Chandra Test Subscribe ------");
                        NSLog(@"Device lock");
                     //   dispatch_async(dispatch_get_main_queue(), ^{
                            [self stopLoadingIndicator];
                            [[self onOffImageView] setImage:[UIImage imageNamed:@"door_closed"] forState: UIControlStateNormal];
                            [self lockStatusLabel].text = @"Door Locked";
                            [self lockStatusLabel].textColor = UIColor.redColor;
                            [self lockDescriptionLabel].text = @"Tap to unlock";
                            [self updateLockStatusWithIsOn: NO];
                       // });
                    } else {
                        NSLog(@"------ Chandra Test Subscribe ------");
                        NSLog(@"Device unlock");
                       // dispatch_async(dispatch_get_main_queue(), ^{
                            [self stopLoadingIndicator];
                            [[self onOffImageView] setImage:[UIImage imageNamed:@"door_opened"] forState: UIControlStateNormal];
                            [self lockStatusLabel].text = @"Door Unlocked";
                            [self lockStatusLabel].textColor = UIColor.greenColor;
                            [self lockDescriptionLabel].text = @"Tap to lock";
                            [self updateLockStatusWithIsOn: YES];
                       // });
                    }
                }];
            } else {
                // got failure response from chip finding chip device
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self toastMessage:@"Failed to establish communication with device." duration:2];
                    [self turnBackToHomeViewController];
                });
            }
            })) {
                NSLog(@"Waiting for connection with the device");
        } else {
            // failed finding chip device with device id
            [self toastMessage:@"Failed to trigger the connection with the device." duration:2];
            [self turnBackToHomeViewController];
        }
    }];
}

- (void)dismissAlertController:(UIAlertController *)alertController {
       [alertController dismissViewControllerAnimated:YES completion:nil];
   }

-(void)didTapOnOn {
   // dispatch_async(dispatch_get_main_queue(), ^{
        [[self loadingIndicator] startAnimating];
        [self loadingIndicator].hidden = NO;
    //});
    [_deviceSelector forSelectedDevices:^(uint64_t deviceId) {
        if (MTRGetConnectedDeviceWithID(deviceId, ^(MTRBaseDevice * _Nullable chipDevice, NSError * _Nullable error) {
                if (chipDevice) {
                    MTRBaseClusterDoorLock * onOff = [[MTRBaseClusterDoorLock alloc] initWithDevice:chipDevice
                                                                                     endpoint:1
                                                                                        queue:dispatch_get_main_queue()];
                    [onOff unlockDoorWithParams:nil completion:^(NSError * error) {
                        NSString * resultString = (error != nil)
                            ? [NSString stringWithFormat:@"An error occurred: 0x%02lx", error.code]
                            : @"On command success";
                        if (error != nil) {
                            // failed while communicating with device ON
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self toastMessage:@"An error occured" duration:2];
                                [self stopLoadingIndicator];
                                [self turnBackToHomeViewController];
                            });
                        } else {
                            [self stopLoadingIndicator];
                            [self updateLockStatusWithIsOn: YES];
                        }
                    }];
                } else {
                    [self stopLoadingIndicator];
                    // got failure response from chip finding chip device
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self toastMessage:@"Failed to establish communication with device." duration:2];
                        [self turnBackToHomeViewController];
                    });
                }
            })) {
                NSLog(@"Waiting for connection with the device");
        } else {
            [self stopLoadingIndicator];
            // failed finding chip device with device id
            dispatch_async(dispatch_get_main_queue(), ^{
                [self toastMessage:@"Failed to trigger the connection with the device." duration:2];
                [self turnBackToHomeViewController];
            });
        }
    }];
}

-(void)stopLoadingIndicator {
   // dispatch_async(dispatch_get_main_queue(), ^{
        [[self loadingIndicator] stopAnimating];
        [self loadingIndicator].hidden = YES;
   // });
}

-(void)didTapOnOff {
   // dispatch_async(dispatch_get_main_queue(), ^{
    [[self loadingIndicator] startAnimating];
        [self loadingIndicator].hidden = NO;
    //});
    
    [_deviceSelector forSelectedDevices:^(uint64_t deviceId) {
        if (MTRGetConnectedDeviceWithID(deviceId, ^(MTRBaseDevice * _Nullable chipDevice, NSError * _Nullable error) {
                if (chipDevice) {
                    MTRBaseClusterDoorLock * onOff = [[MTRBaseClusterDoorLock alloc] initWithDevice:chipDevice
                                                                                     endpoint:1
                                                                                        queue:dispatch_get_main_queue()];
                    [onOff lockDoorWithParams:nil completion:^(NSError * error) {
                        NSString * resultString = (error != nil)
                            ? [NSString stringWithFormat:@"An error occurred: 0x%02lx", error.code]
                            : @"Off command success";
                        if (error != nil) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self toastMessage:@"An error occured" duration:2];
                                [self stopLoadingIndicator];

                                [self turnBackToHomeViewController];
                            });
                        } else {
                            [self stopLoadingIndicator];
                            [self updateLockStatusWithIsOn: NO];
                        }
                    }];
                } else {
                    [self stopLoadingIndicator];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self toastMessage:@"Failed to establish connection with device." duration:2];
                        [self turnBackToHomeViewController];
                    });
                }
            })) {
                NSLog(@"Waiting for connection with the device");
        } else {
            [self stopLoadingIndicator];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self toastMessage:@"Failed to trigger the connection with the device." duration:2];
                [self turnBackToHomeViewController];
            });
        }
    }];
}

@end
