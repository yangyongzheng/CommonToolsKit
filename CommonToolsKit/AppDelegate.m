//
//  AppDelegate.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/10/12.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import "AppDelegate.h"
#import "CommonToolsLibraryHeader.h"

@interface AppDelegate ()<CTLLocationManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UIApplication.sharedApplication ctl_enabledRemoteNotification:^(BOOL enabled) {
        if (enabled) {
            NSLog(@"已开启");
        } else {
            NSLog(@"未开启");
        }
    }];
    
    [CTLLocationManager.defaultManager addDelegate:self];
    [CTLLocationManager.defaultManager startUpdatingLocation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [CTLLocationManager.defaultManager startUpdatingLocation];
    });
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - CTLLocationManagerDelegate
- (void)locationManager:(CTLLocationManager *)manager reverseGeocodeLocation:(CTLLocationInfo *)locationInfo {
    
}

@end
