//
//  UIApplication+CTLHelper.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/11/5.
//  Copyright © 2018 yangyongzheng. All rights reserved.
//

#import "UIApplication+CTLHelper.h"

@implementation UIApplication (CTLHelper)

- (void)ctl_safeOpenURL:(NSURL *)url {
    // [UIApplication canOpenURL:] must be used from main thread only
    // [UIApplication openURL:options:completionHandler:] must be used from main thread only
    if (url && [url isKindOfClass:[NSURL class]]) {
        CTLSafeSyncMainQueueHandler(^{
            if ([UIApplication.sharedApplication canOpenURL:url]) {
                if (@available(iOS 10.0, *)) {
                    [UIApplication.sharedApplication openURL:url options:@{} completionHandler:nil];
                } else {
                    [UIApplication.sharedApplication openURL:url];
                }
            }
        });
    }
}

- (void)ctl_openAppSettings {
    NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [self ctl_safeOpenURL:settingsURL];
}

@end
