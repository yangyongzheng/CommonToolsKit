//
//  CTLLocationManager.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/11/27.
//  Copyright © 2018 yangyongzheng. All rights reserved.
//

#import "CTLLocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface CTLLocationManager ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
// 存储定位代理的集合(类似NSSet), 自动释放nil对象
@property (nonatomic, readonly, strong) NSHashTable *delegateContainer;
@end

@implementation CTLLocationManager

+ (CTLLocationManager *)defaultManager {
    static CTLLocationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CTLLocationManager alloc] init];
        [manager defaultConfiguration];
    });
    
    return manager;
}

- (void)defaultConfiguration {
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

- (void)startLocation {
    
}

#pragma mark - CLLocationManagerDelegate


- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    
    return _locationManager;
}

@end
