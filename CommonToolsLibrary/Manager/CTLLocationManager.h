//
//  CTLLocationManager.h
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/11/27.
//  Copyright © 2018 yangyongzheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "CTLLocationInfo.h"

NS_ASSUME_NONNULL_BEGIN

/**
 定位权限授权状态
 隐私权限声明 key：
 NSLocationAlwaysAndWhenInUseUsageDescription : "请允许$(PRODUCT_NAME)访问您的位置"
 NSLocationWhenInUseUsageDescription : "请允许$(PRODUCT_NAME)访问您的位置"
 NSLocationAlwaysUsageDescription : "请允许$(PRODUCT_NAME)访问您的位置"
 
 - CTLLocationAuthorizationStatusServicesDisabled: 未开启定位服务
 - CTLLocationAuthorizationStatusNotDetermined: 用户尚未对当前App访问权限做出选择
 - CTLLocationAuthorizationStatusRestricted: 当前App未被授权访问，用户无法更改状态，可能是由于父母控制等主动限制所致
 - CTLLocationAuthorizationStatusDenied: 用户已明确拒绝当前App访问权限
 - CTLLocationAuthorizationStatusAuthorizedAlways: 用户已授权随时使用其位置
 - CTLLocationAuthorizationStatusAuthorizedWhenInUse: App在前台运行期间允许使用用户位置
 */
typedef NS_ENUM(NSInteger, CTLLocationAuthorizationStatus) {
    CTLLocationAuthorizationStatusServicesDisabled  = -1,
    CTLLocationAuthorizationStatusNotDetermined     = 0,
    CTLLocationAuthorizationStatusRestricted,
    CTLLocationAuthorizationStatusDenied,
    CTLLocationAuthorizationStatusAuthorizedAlways,
    CTLLocationAuthorizationStatusAuthorizedWhenInUse
} NS_ENUM_AVAILABLE_IOS(8_0);

/** 定位状态 */
typedef NS_ENUM(NSInteger, CTLLocationState) {
    CTLLocationStateIdle = 0,   // 闲置
    CTLLocationStateUpdating,   // 正在定位中
    CTLLocationStateSuccess,    // 定位成功，正在进行反向地理编码
    CTLLocationStateFailure,    // 定位失败
    CTLLocationStateReverseGeocodingCompletion, // 反向地理编码完成
};

/** 访问位置信息权限发生改变通知 */
CL_EXTERN NSNotificationName const CTLLocationAuthorizationStatusDidChangeNotification;


@class CTLLocationManager;
@protocol CTLLocationManagerDelegate <NSObject>
@optional
/**
 更新位置信息成功时调用
 
 @param location 用户当前位置信息
 */
- (void)locationManager:(CTLLocationManager *)manager
      didUpdateLocation:(CLLocation *)location;

/**
 更新位置信息失败时调用
 
 @param error errorCode为 CLError 枚举值
 */
- (void)locationManager:(CTLLocationManager *)manager
       didFailWithError:(NSError *)error;

/**
 反向地理编码完成时调用
 
 @param locationInfo 反向地理编码成功后位置信息
 */
- (void)locationManager:(CTLLocationManager *)manager
 reverseGeocodeLocation:(nullable CTLLocationInfo *)locationInfo
                  error:(nullable NSError *)error;
@end


@interface CTLLocationManager : NSObject

// 获取单例
@property (class, nonatomic, readonly, strong) CTLLocationManager *defaultManager;
// 定位权限授权状态
@property (class, nonatomic, readonly) CTLLocationAuthorizationStatus locationAuthorizationStatus;

// 定位精度，默认值为`kCLLocationAccuracyBest`
@property(nonatomic) CLLocationAccuracy desiredAccuracy;
// 触发定位更新的水平移动最小距离（单位米），默认值为10m
@property(nonatomic) CLLocationDistance distanceFilter;

/** 用户位置信息 */
@property (nonatomic, readonly, strong) CLLocation *lastLocation;           // 最新的位置信息
@property (nonatomic, readonly, strong) CTLLocationInfo *lastLocationInfo;  // 反地理编码后位置信息
// 当前定位状态
@property (nonatomic, readonly) CTLLocationState locationState;

/**
 添加/移除定位代理
 */
- (void)addDelegate:(id<CTLLocationManagerDelegate>)delegate;
- (void)removeDelegate:(id<CTLLocationManagerDelegate>)delegate;

/**
 开始定位，建议调用此API之前优先设置代理以及相关配置信息，如`desiredAccuracy`，`distanceFilter`。
 如果当前定位授权状态为`CTLLocationAuthorizationStatusNotDetermined`调用此API会默认请求‘requestLocationAuthorizationWhenInUse’授权。
 注意：只有当 locationState == CTLLocationStateIdle ||
            locationState == CTLLocationStateFailure ||
            locationState == CTLLocationStateReverseGeocodingCompletion
 时，调用此方法才会触发下一次定位更新。
 */
- (void)startUpdatingLocation;

/**
 当授权状态为`CTLLocationAuthorizationStatusNotDetermined`时调用此API请求授权
 */
- (void)requestLocationAuthorizationWhenInUse;
- (void)requestLocationAuthorizationAlways;

@end

NS_ASSUME_NONNULL_END
