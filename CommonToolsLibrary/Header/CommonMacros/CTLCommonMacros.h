//
//  CTLCommonMacros.h
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/11/1.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#ifndef CTLCommonMacros_h
#define CTLCommonMacros_h

#import <UIKit/UIKit.h>

#define CTL_EXTERN          UIKIT_EXTERN
#define CTL_STATIC_INLINE   UIKIT_STATIC_INLINE

// 制定工程AppDelegate类
#define CTLAppDelegate      AppDelegate

// 单例宏
#define CTLSharedAppDelegate ((CTLAppDelegate *)UIApplication.sharedApplication.delegate)
#define CTLSharedUserDefaults NSUserDefaults.standardUserDefaults
#define CTLSharedFileManager NSFileManager.defaultManager
#define CTLSharedNotificationCenter NSNotificationCenter.defaultCenter

// 屏幕相关高度
#define CTLScreenWidth                      UIScreen.mainScreen.bounds.size.width
#define CTLScreenHeight                     UIScreen.mainScreen.bounds.size.height
#define CTLStatusBarHeight                  CTLSafeAreaManager.defaultManager.statusBarHeight
#define CTLSafeAreaTopMargin                CTLSafeAreaManager.defaultManager.safeAreaTopMargin
#define CTLSafeAreaBottomMargin             CTLSafeAreaManager.defaultManager.safeAreaBottomMargin
#define CTLAdditionalSafeAreaBottomMargin   CTLSafeAreaManager.defaultManager.additionalSafeAreaBottomMargin

// App信息
#define CTLSystemVersion UIDevice.currentDevice.systemVersion

// RGB色值，注意r/g/b取值范围为[0.0f 255.0f]，a取值范围[0.0f 1.0f]
#define CTLColorWithRGBA(r, g, b, a) [UIColor colorWithRed:((r)/255.0f) green:((g)/255.0f) blue:((b)/255.0f) alpha:(a)]
#define CTLColorWithRGB(r, g, b) CTLColorWithRGBA(r, g, b, 1.0f)
#define CTLColorWithHEX(hex) nil

#endif /* CTLCommonMacros_h */
