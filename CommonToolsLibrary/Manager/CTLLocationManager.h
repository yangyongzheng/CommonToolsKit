//
//  CTLLocationManager.h
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/11/27.
//  Copyright © 2018 yangyongzheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CTLLocationInfo : NSObject

@property (nonatomic, strong) CLLocation *location;             // 定位信息
@property (nonatomic, strong) CLPlacemark *placemark;           // 反地理编码后位置信息
// 位置经纬度, 根据`location`属性获得
@property (nonatomic, readonly) CLLocationDegrees latitude;     // 纬度
@property (nonatomic, readonly) CLLocationDegrees longitude;    // 经度
// 反地理编码后位置信息 相关属性 根据`placemark`属性获得
@property (nonatomic, readonly, copy) NSString *country;        // 国家
@property (nonatomic, readonly, copy) NSString *province;       // 省
@property (nonatomic, readonly, copy) NSString *city;           // 市
@property (nonatomic, readonly, copy) NSString *district;       // 区
@property (nonatomic, readonly, copy) NSString *street;         // 街道
@property (nonatomic, readonly, copy) NSString *landmark;       // 标志物
// extra
@property (nonatomic, readonly, copy) NSString *shortAddress;   // 短地址（省+市）
@property (nonatomic, readonly, copy) NSString *mediumAddress;  // 中地址（省+市+区）
@property (nonatomic, readonly, copy) NSString *longAddress;    // 长地址（省+市+区+街道）
@property (nonatomic, readonly, copy) NSString *fullAddress;    // 完整地址（省+市+区+街道+标志物）

+ (instancetype)locationInfoWithLocation:(CLLocation *)location placemark:(CLPlacemark *)placemark;

@end


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


@class CTLLocationManager;
@protocol CTLLocationManagerDelegate <NSObject>
@optional

/**
 定位成功时调用，可能多次调用
 
 @param location 用户当前位置
 */
- (void)locationManager:(CTLLocationManager *)manager didUpdateLocation:(CLLocation *)location;

/**
 定位失败时调用
 
 @param error errorCode为 CLError 枚举值
 */
- (void)locationManager:(CTLLocationManager *)manager didFailWithError:(NSError *)error;

/**
 反向地理编码成功时调用
 
 @param locationInfo 反向地理编码成功后位置信息
 */
- (void)locationManager:(CTLLocationManager *)manager reverseGeocodeLocation:(CTLLocationInfo *)locationInfo;

/**
 定位权限变更时调用
 
 @param status 注意：未开启【定位服务】时也会报`kCLAuthorizationStatusDenied`权限状态
 */
- (void)locationManager:(CTLLocationManager *)manager didChangeAuthorizationStatus:(CTLLocationAuthorizationStatus)status;

@end


@interface CTLLocationManager : NSObject

// 获取单例
@property (class, nonatomic, readonly, strong) CTLLocationManager *defaultManager;
// 定位权限授权状态
@property (class, nonatomic, readonly) CTLLocationAuthorizationStatus locationAuthorizationStatus;

/** 用户位置信息 */
@property (nonatomic, readonly, strong) CLLocation *lastLocation;           // 最新的位置信息
@property (nonatomic, readonly, strong) CTLLocationInfo *lastLocationInfo;  // 反地理编码后位置信息

/**
 添加/移除定位代理
 */
- (void)addDelegate:(id<CTLLocationManagerDelegate>)delegate;
- (void)removeDelegate:(id<CTLLocationManagerDelegate>)delegate;

/**
 开始定位，建议调用此API之前优先设置代理.
 */
- (void)startUpdatingLocation;

/**
 当授权状态为`CTLLocationAuthorizationStatusNotDetermined`时调用此API请求授权
 */
- (void)requestLocationAuthorizationWhenInUse;
- (void)requestLocationAuthorizationAlways;

@end

NS_ASSUME_NONNULL_END
