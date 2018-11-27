//
//  CTLAuthorizeManager.h
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/11/26.
//  Copyright © 2018 yangyongzheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** iOS 10 开始对隐私权限管理更加严格, 如需使用隐私权限需要在工程的Info.plist文件中声明, 如果不声明程序在调用隐私权限（如相机/相册等）时应用程序会崩溃. */

/**
 相册/相机访问权限授权状态
 隐私权限声明 key：
 访问相册 NSPhotoLibraryUsageDescription : "请允许$(PRODUCT_NAME)访问您的相册".
 添加图片到相册 NSPhotoLibraryAddUsageDescription : "请允许$(PRODUCT_NAME)访问您的相册".
 访问相机 NSCameraUsageDescription : "请允许$(PRODUCT_NAME)访问您的相机".

 - CTLPHAuthorizationStatusNotDetermined: 用户尚未对当前App访问权限做出选择
 - CTLPHAuthorizationStatusRestricted: 当前App未被授权访问，用户无法更改状态，可能是由于父母控制等主动限制所致
 - CTLPHAuthorizationStatusDenied: 用户已明确拒绝当前App访问权限
 - CTLPHAuthorizationStatusAuthorized: 用户已授权当前App访问权限
 */
typedef NS_ENUM(NSInteger, CTLPHAuthorizationStatus) {
    CTLPHAuthorizationStatusNotDetermined = 0,
    CTLPHAuthorizationStatusRestricted,
    CTLPHAuthorizationStatusDenied,
    CTLPHAuthorizationStatusAuthorized
} NS_ENUM_AVAILABLE_IOS(8_0);

NS_CLASS_AVAILABLE_IOS(8_0) @interface CTLAuthorizeManager : NSObject
// 相册授权状态
@property (class, nonatomic, readonly) CTLPHAuthorizationStatus albumAuthorizationStatus;
// 相机授权状态
@property (class, nonatomic, readonly) CTLPHAuthorizationStatus cameraAuthorizationStatus;

// 当授权状态为`CTLPHAuthorizationStatusNotDetermined`时调用以下请求授权API
+ (void)requestAlbumAuthorization:(void(^)(CTLPHAuthorizationStatus status))resultHandler;
+ (void)requestCameraAccessAuthorization:(void(^)(CTLPHAuthorizationStatus status))resultHandler;

@end

NS_ASSUME_NONNULL_END
