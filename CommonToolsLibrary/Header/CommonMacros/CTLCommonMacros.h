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


#ifndef CTL_EXTERN
#define CTL_EXTERN          UIKIT_EXTERN
#endif

#ifndef CTL_STATIC_INLINE
#define CTL_STATIC_INLINE   UIKIT_STATIC_INLINE
#endif

// 制定工程AppDelegate类
#ifndef CTLAppDelegate
#define CTLAppDelegate      AppDelegate
#endif


// 单例宏
#ifndef CTLSharedAppDelegate
#define CTLSharedAppDelegate                ((CTLAppDelegate *)UIApplication.sharedApplication.delegate)
#endif

#ifndef CTLSharedUserDefaults
#define CTLSharedUserDefaults               NSUserDefaults.standardUserDefaults
#endif

#ifndef CTLSharedFileManager
#define CTLSharedFileManager                NSFileManager.defaultManager
#endif

#ifndef CTLSharedNotificationCenter
#define CTLSharedNotificationCenter         NSNotificationCenter.defaultCenter
#endif


// 屏幕相关高度
#ifndef CTLScreenWidth
#define CTLScreenWidth                      UIScreen.mainScreen.bounds.size.width
#endif

#ifndef CTLScreenHeight
#define CTLScreenHeight                     UIScreen.mainScreen.bounds.size.height
#endif

#ifndef CTLStatusBarHeight
#define CTLStatusBarHeight                  UIApplication.sharedApplication.statusBarFrame.size.height
#endif

#ifndef CTLSafeAreaTopMargin
#define CTLSafeAreaTopMargin                (CTLStatusBarHeight + 44.0f)
#endif

#ifndef CTLAdditionalSafeAreaBottomMargin
#define CTLAdditionalSafeAreaBottomMargin   CTLDevice.currentDevice.additionalSafeAreaBottomMargin
#endif

#ifndef CTLSafeAreaBottomMargin
#define CTLSafeAreaBottomMargin             (CTLAdditionalSafeAreaBottomMargin + 49.0f)
#endif


// App信息
#ifndef CTLSystemVersion
#define CTLSystemVersion                    UIDevice.currentDevice.systemVersion
#endif

#ifndef CTLCompileTimestamp
// use macro to avoid compile warning when use pch file
#define CTLCompileTimestamp                 __CTLCompileTimestamp(__DATE__, __TIME__)
#endif


// UIColor
#ifndef CTLColorWithRGBA
#define CTLColorWithRGBA(r, g, b, a)        [UIColor colorWithRed:((r)/255.0f) green:((g)/255.0f) blue:((b)/255.0f) alpha:(a)]
#endif

#ifndef CTLColorWithRGB
#define CTLColorWithRGB(r, g, b)            CTLColorWithRGBA(r, g, b, 1.0f)
#endif

#ifndef CTLColorWithHexString
#define CTLColorWithHexString(hexString)    [UIColor ctl_colorWithHexString:hexString]
#endif

#ifndef CTLColorWithHexInt
#define CTLColorWithHexInt(hexInt)          [UIColor ctl_colorWithHexInt:hexInt]
#endif


#endif /* CTLCommonMacros_h */
