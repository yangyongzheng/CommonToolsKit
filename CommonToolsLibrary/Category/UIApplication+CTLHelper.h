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
- (void)ctl_openAppSettings;

@end

NS_ASSUME_NONNULL_END
