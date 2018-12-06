//
//  CTLLocationInfo.h
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/11/28.
//  Copyright © 2018 yangyongzheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CLLocation, CLPlacemark;

@interface CTLLocationInfo : NSObject
@property (nonatomic, strong) CLLocation *location;             // 定位信息
@property (nonatomic, strong) CLPlacemark *placemark;           // 反地理编码后位置信息
// 位置经纬度, 根据`location`属性获得
@property (nonatomic, readonly) double latitude;                // 纬度
@property (nonatomic, readonly) double longitude;               // 经度
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

NS_ASSUME_NONNULL_END
