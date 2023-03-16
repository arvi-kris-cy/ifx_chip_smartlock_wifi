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

#import "AppDelegate.h"
#import "RootViewController.h"
#import "SmartLock-Swift.h"
#import "IQKeyboardManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self configureAmplify];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    MainViewController *rootVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
      //rootview controller
    instantiateViewControllerWithIdentifier:@"MainViewController"];
    UINavigationController * navController =
        [[UINavigationController alloc] initWithRootViewController:rootVC];
    [navController setNavigationBarHidden: YES];
    [self.window setRootViewController:navController];
    [self.window makeKeyAndVisible];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    // custom commissioning flow
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Info"
                                                                    message:@"Commissioning flow Completed."
                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:ok];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    NSLog(@"Do custom commissioning inbound logic here.");
    return YES;
}
@end
