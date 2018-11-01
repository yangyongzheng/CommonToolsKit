//
//  CTLCommonMacros.h
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/11/1.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#ifndef CTLCommonMacros_h
#define CTLCommonMacros_h

#define CMLKIT_EXTERN UIKIT_EXTERN
#define CMLKIT_STATIC_INLINE UIKIT_STATIC_INLINE

// 单例宏
#define CMLSharedAppDelegate ((AppDelegate *)UIApplication.sharedApplication.delegate)
#define CMLSharedUserDefaults NSUserDefaults.standardUserDefaults
#define CMLSharedFileManager NSFileManager.defaultManager

// 设备相关
#define CMLScreenWidth UIScreen.mainScreen.bounds.size.width
#define CMLScreenHeight UIScreen.mainScreen.bounds.size.height
#define CMLStatusBarHeight UIApplication.sharedApplication.statusBarFrame.size.height
#define CMLSafeAreaTopMargin (CMLStatusBarHeight + 44)
#define CMLTabBarAdditionHeight ([YZDeviceInfo isIPhoneX] ? 34 : 0)
#define CMLSafeAreaBottomMargin (CMLTabBarAdditionHeight + 49)
#define CMLSystemVersion UIDevice.currentDevice.systemVersion

// 常用沙盒路径
#define CMLSandboxDocumentsPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
#define CMLSandboxTempPath NSTemporaryDirectory()
#define CMLSandboxCachesPath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

// RGB色值，注意r/g/b取值范围为[0.0f 255.0f]，a取值范围[0.0f 1.0f]
#define CMLRGBA(r, g, b, a) [UIColor colorWithRed:((r)/255.0f) green:((g)/255.0f) blue:((b)/255.0f) alpha:(a)]
#define CMLRGB(r, g, b) CMLRGBA(r, g, b, 1.0f)

// 从 UIStoryboard 实例化 UIViewController
#define CMLInstantiateViewController(storyboardName, identifier) [[UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:identifier]

#endif /* CTLCommonMacros_h */
