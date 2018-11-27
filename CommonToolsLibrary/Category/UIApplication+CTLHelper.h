//
//  UIApplication+CTLHelper.h
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/11/5.
//  Copyright © 2018 yangyongzheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (CTLHelper)

- (void)ctl_safeOpenURL:(NSURL *)url;
- (void)ctl_openAppSettings NS_AVAILABLE_IOS(8_0);

/** 是否开启了Push通知 */
- (void)ctl_enabledRemoteNotification:(void(^)(BOOL enabled))completionHandler;

@end

NS_ASSUME_NONNULL_END
