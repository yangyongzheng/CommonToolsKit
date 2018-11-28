//
//  CTLLocationManager.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/11/27.
//  Copyright © 2018 yangyongzheng. All rights reserved.
//

#import "CTLLocationManager.h"

NSNotificationName const CTLLocationAuthorizationStatusDidChangeNotification = @"CTLLocationAuthorizationStatusDidChangeNotification";

#pragma mark - 定位管理类
@interface CTLLocationManager ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
// 存储定位代理的集合(类似NSSet), 自动释放nil对象
@property (nonatomic, strong) NSHashTable *delegateContainer;
@property (nonatomic) BOOL isNeedUpdate;
@end

@implementation CTLLocationManager

#pragma mark - Public Method
+ (CTLLocationManager *)defaultManager {
    static CTLLocationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CTLLocationManager alloc] init];
    });
    
    return manager;
}

+ (CTLLocationAuthorizationStatus)locationAuthorizationStatus {
    if ([CLLocationManager locationServicesEnabled]) {
        return (CTLLocationAuthorizationStatus)[CLLocationManager authorizationStatus];
    } else {
        return CTLLocationAuthorizationStatusServicesDisabled;
    }
}

- (void)addDelegate:(id<CTLLocationManagerDelegate>)delegate {
    [self.delegateContainer addObject:delegate];
}

- (void)removeDelegate:(id<CTLLocationManagerDelegate>)delegate {
    [self.delegateContainer removeObject:delegate];
}

- (void)startUpdatingLocation {
    self.isNeedUpdate = YES;
    [self.locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation {
    self.isNeedUpdate = NO;
    [self.locationManager stopUpdatingLocation];
}

- (void)requestLocationAuthorizationWhenInUse {
    [self.locationManager requestWhenInUseAuthorization];
}

- (void)requestLocationAuthorizationAlways {
    [self.locationManager requestAlwaysAuthorization];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    // 更新位置成功时调用
    if (locations.count > 0 && self.isNeedUpdate) {
        self.isNeedUpdate = NO;
        [self stopUpdatingLocation];
        _lastLocation = locations.lastObject;
        // 反向地理编码
        [self requestReverseGeocodeLocation:_lastLocation];
        // 代理通知
        for (id <CTLLocationManagerDelegate> delegate in self.delegateContainer) {
            if (delegate && [delegate respondsToSelector:@selector(locationManager:didUpdateLocation:)]) {
                [delegate locationManager:self didUpdateLocation:self.lastLocation];
            }
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // 代理通知
    [self stopUpdatingLocation];
    for (id <CTLLocationManagerDelegate> delegate in self.delegateContainer) {
        if (delegate && [delegate respondsToSelector:@selector(locationManager:didFailWithError:)]) {
            [delegate locationManager:self didFailWithError:error];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusNotDetermined) {
        [self requestLocationAuthorizationWhenInUse];
    }
    [NSNotificationCenter.defaultCenter postNotificationName:CTLLocationAuthorizationStatusDidChangeNotification
                                                      object:nil
                                                    userInfo:nil];
}

#pragma mark - Misc
#pragma mark 请求反地理编码
- (void)requestReverseGeocodeLocation:(CLLocation *)location {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    __weak typeof(self) weakSelf = self;
    if (@available(iOS 11.0, *)) {
        NSLocale *preferredLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans"];
        [geocoder reverseGeocodeLocation:location preferredLocale:preferredLocale completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf reverseGeocodeLocation:location placemarks:placemarks error:error];
        }];
    } else {
        NSArray *languages = [NSUserDefaults.standardUserDefaults objectForKey:@"AppleLanguages"];
        [NSUserDefaults.standardUserDefaults setObject:@[@"zh-Hans"] forKey:@"AppleLanguages"];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf reverseGeocodeLocation:location placemarks:placemarks error:error];
            [NSUserDefaults.standardUserDefaults setObject:languages forKey:@"AppleLanguages"];
        }];
    }
}

- (void)reverseGeocodeLocation:(CLLocation *)location placemarks:(NSArray<CLPlacemark *> *)placemarks error:(NSError *)error {
    if (!error && placemarks.count > 0) {
        CLPlacemark *place = placemarks.lastObject;
        _lastLocationInfo = [CTLLocationInfo locationInfoWithLocation:location placemark:place];
    }
    
    // 代理通知
    for (id <CTLLocationManagerDelegate> delegate in self.delegateContainer) {
        if (delegate && [delegate respondsToSelector:@selector(locationManager:reverseGeocodeLocation:error:)]) {
            [delegate locationManager:self reverseGeocodeLocation:self.lastLocationInfo error:error];
        }
    }
}

#pragma mark - setter or getter
- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (NSHashTable *)delegateContainer {
    if (!_delegateContainer) {
        _delegateContainer = [NSHashTable weakObjectsHashTable];
    }
    return _delegateContainer;
}

@end

