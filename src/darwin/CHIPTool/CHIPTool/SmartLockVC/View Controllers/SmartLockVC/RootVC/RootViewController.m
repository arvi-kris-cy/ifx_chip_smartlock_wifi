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

#import "RootViewController.h"
#import "BindingsViewController.h"
//#import "EchoViewController.h"
#import "FabricUIViewController.h"
#import "MultiAdminViewController.h"
#import "QRCodeViewController.h"
#import "TemperatureSensorViewController.h"
#import "UnpairDevicesViewController.h"
#import "WiFiViewController.h"
#import "SmartLock-Swift.h"

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateUI];
    _userNameTF.delegate = self;
    _userNameTF.returnKeyType = UIReturnKeyDone;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
    case 0:
        [self pushQRCodeScanner];
        break;
    case 1:
        [self pushEchoClient];
        break;
    case 2:
        [self pushLightOnOffCluster];
        break;
    case 3:
        [self pushTemperatureSensor];
        break;
    case 4:
        [self pushBindings];
        break;
    case 5:
        [self pushNetworkConfiguration];
        break;
    case 6:
        [self pushMultiAdmin];
        break;
    case 7:
        [self pushUnpairDevices];
        break;
    case 8:
        [self pushFabric];
        break;
    default:
        break;
    }
}
*/
- (void)pushFabric
{
    FabricUIViewController * controller = [FabricUIViewController new];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)pushBindings
{
    BindingsViewController * controller = [BindingsViewController new];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)pushTemperatureSensor
{
    TemperatureSensorViewController * controller = [TemperatureSensorViewController new];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)pushNetworkConfiguration
{
    WiFiViewController * controller = [WiFiViewController new];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)pushQRCodeScanner
{
    QRCodeViewController * controller = [QRCodeViewController new];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)pushEchoClient
{
//    EchoViewController * controller = [EchoViewController new];
//    [self.navigationController pushViewController:controller animated:YES];
}

- (void)pushMultiAdmin
{
    MultiAdminViewController * controller = [MultiAdminViewController new];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)pushLightOnOffCluster
{
//    OnOffViewController * controller = [OnOffViewController new];
//    [self.navigationController pushViewController:controller animated:YES];
}

- (void)pushUnpairDevices
{
    UnpairDevicesViewController * controller = [UnpairDevicesViewController new];
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)didTapOnProceed:(id)sender {
    if ([self.userNameTF.text  isEqual: @""]) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Please enter username" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    } else  if ([self.passwordTf.text  isEqual: @""]) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Please enter Password" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    } else {
        [self saveNameWithName: self.userNameTF.text];
        [self signInUsername:self.userNameTF.text password:self.passwordTf.text];
    }
}
- (IBAction)signUpButton:(id)sender {
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    SignUpViewController *myNewVC = (SignUpViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
//    [self.navigationController pushViewController:myNewVC animated:YES];
}


@end
