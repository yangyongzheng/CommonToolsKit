//
//  UIApplication+CTLHelper.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/11/5.
//  Copyright © 2018 yangyongzheng. All rights reserved.
//

#import "UIApplication+CTLHelper.h"
#import "CTLCommonFunction.h"
#import <UserNotifications/UserNotifications.h>

@implementation UIApplication (CTLHelper)

- (void)ctl_safeOpenURL:(NSURL *)url {
    // [UIApplication canOpenURL:] must be used from main thread only
    // [UIApplication openURL:options:completionHandler:] must be used from main thread only
    if (url && [url isKindOfClass:[NSURL class]]) {
        CTLSafeSyncMainQueueHandler(^{
            if ([self canOpenURL:url]) {
                if (@available(iOS 10.0, *)) {
                    [self openURL:url options:@{} completionHandler:nil];
                } else {
                    [self openURL:url];
                }
            }
        });
    }
}

- (void)ctl_openAppSettings {
    NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [self ctl_safeOpenURL:settingsURL];
}

- (void)ctl_enabledRemoteNotification:(void (^)(BOOL))completionHandler {
    // 判断应用是否注册远程通知
    if ([self isRegisteredForRemoteNotifications]) {
        if (@available(iOS 10.0, *)) {
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            __weak typeof(center) weakCenter = center;
            [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                CTLSafeSyncMainQueueHandler(^{
                    if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined) {
                        __strong typeof(weakCenter) strongCenter = weakCenter;
                        UNAuthorizationOptions options = UNAuthorizationOptionBadge|UNAuthorizationOptionSound|UNAuthorizationOptionAlert|UNAuthorizationOptionCarPlay;
                        [strongCenter requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
                            CTLSafeSyncMainQueueHandler(^{
                                if (completionHandler) {completionHandler(granted);}
                            });
                        }];
                    } else if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
                        if (settings.badgeSetting == UNNotificationSettingEnabled ||
                            settings.soundSetting == UNNotificationSettingEnabled ||
                            settings.alertSetting == UNNotificationSettingEnabled) {
                            if (completionHandler) {completionHandler(YES);}
                        } else {
                            if (completionHandler) {completionHandler(NO);}
                        }
                    } else {
                        if (completionHandler) {completionHandler(NO);}
                    }
                });
            }];
        } else {
            UIUserNotificationSettings *notiSettings = [self currentUserNotificationSettings];
            if (notiSettings.types == UIUserNotificationTypeNone) {
                if (completionHandler) {completionHandler(NO);}
            } else {
                if (completionHandler) {completionHandler(YES);}
            }
        }
    } else {
        if (completionHandler) {completionHandler(NO);}
    }
}

@end
