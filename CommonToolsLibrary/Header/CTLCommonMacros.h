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

#define CTLKIT_EXTERN UIKIT_EXTERN
#define CTLKIT_STATIC_INLINE UIKIT_STATIC_INLINE

// 单例宏
#define CTLSharedAppDelegate ((AppDelegate *)UIApplication.sharedApplication.delegate)
#define CTLSharedUserDefaults NSUserDefaults.standardUserDefaults
#define CTLSharedFileManager NSFileManager.defaultManager

// 屏幕相关高度
#define CTLScreenWidth UIScreen.mainScreen.bounds.size.width
#define CTLScreenHeight UIScreen.mainScreen.bounds.size.height
#define CTLStatusBarHeight CTLSafeAreaManager.defaultManager.statusBarHeight
#define CTLSafeAreaTopMargin CTLSafeAreaManager.defaultManager.safeAreaTopMargin
#define CTLSafeAreaBottomMargin CTLSafeAreaManager.defaultManager.safeAreaBottomMargin
#define CTLAdditionalSafeAreaBottomMargin CTLSafeAreaManager.defaultManager.additionalSafeAreaBottomMargin

// App信息
#define CTLSystemVersion UIDevice.currentDevice.systemVersion

// 常用沙盒路径
#define CTLSandboxDocumentsPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
#define CTLSandboxTempPath NSTemporaryDirectory()
#define CTLSandboxCachesPath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

// RGB色值，注意r/g/b取值范围为[0.0f 255.0f]，a取值范围[0.0f 1.0f]
#define CTLColorWithRGBA(r, g, b, a) [UIColor colorWithRed:((r)/255.0f) green:((g)/255.0f) blue:((b)/255.0f) alpha:(a)]
#define CTLColorWithRGB(r, g, b) CTLColorWithRGBA(r, g, b, 1.0f)
#define CTLColorWithHEX(hex) nil

#endif /* CTLCommonMacros_h */
