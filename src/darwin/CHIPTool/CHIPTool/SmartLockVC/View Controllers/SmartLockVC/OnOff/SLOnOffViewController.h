//
//  SLOnOffViewController.h
//  CHIPTool
//
//  Created by Chandra Sekhar on 17/05/22.
//  Copyright © 2022 CHIP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Matter/Matter.h>
NS_ASSUME_NONNULL_BEGIN

@interface SLOnOffViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
// OnOff
@property (weak, nonatomic) IBOutlet UIButton *onOffImageView;
@property (weak, nonatomic) IBOutlet UILabel *lockStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *lockDescriptionLabel;
@property (assign) BOOL isFromHomeScreen;
@property (assign) BOOL isRemoteAccessUsingAWSIotEnabled;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UIView *batteryPercentageView;
@property (weak, nonatomic) IBOutlet UILabel *batteryPercentageLabel;
@property (weak, nonatomic) IBOutlet UILabel *connectingViaLabel;
@property (assign) BOOL isFirstLoad;
@property (assign) BOOL isAwsResonseReceived;

-(void)turnBackToHomeViewController;
-(void)subscribeToAWS;

@end

NS_ASSUME_NONNULL_END
