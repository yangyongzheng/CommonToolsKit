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
@property (nonatomic, strong) CLLocationManager *locationManager;           // 定位管理类
@property (nonatomic, strong) NSHashTable *delegateContainer;               // 存储定位代理的集合(类似NSSet), 自动释放nil对象
@property (nonatomic, readwrite, strong) CLLocation *lastLocation;          // 最新的位置信息
@property (nonatomic, readwrite, strong) CTLLocationInfo *lastLocationInfo; // 反地理编码后位置信息
@property (nonatomic, readwrite) CTLLocationState locationState;            // 当前定位状态
@end

@implementation CTLLocationManager

#pragma mark - setter or getter
- (void)setDistanceFilter:(CLLocationDistance)distanceFilter {
    _distanceFilter = distanceFilter;
    
    self.locationManager.distanceFilter = distanceFilter;
}

- (void)setDesiredAccuracy:(CLLocationAccuracy)desiredAccuracy {
    _desiredAccuracy = desiredAccuracy;
    
    self.locationManager.desiredAccuracy = desiredAccuracy;
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 10;
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

#pragma mark - Public Method
+ (CTLLocationManager *)defaultManager {
    static CTLLocationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CTLLocationManager alloc] init];
        manager.distanceFilter = 10;
        manager.desiredAccuracy = kCLLocationAccuracyBest;
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
    if (self.locationState == CTLLocationStateIdle ||
        self.locationState == CTLLocationStateFailure ||
        self.locationState == CTLLocationStateReverseGeocodingCompletion) {
        self.locationState = CTLLocationStateUpdating;
        [self.locationManager startUpdatingLocation];
    }
}

- (void)stopUpdatingLocation {
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
    BOOL enabled = self.locationState != CTLLocationStateSuccess && self.locationState != CTLLocationStateReverseGeocodingCompletion;
    if (locations.count > 0 && enabled) {
        self.locationState = CTLLocationStateSuccess;
        [self stopUpdatingLocation];
        self.lastLocation = locations.lastObject;
        // 反向地理编码
        [self requestReverseGeocodeLocation:self.lastLocation];
        // 代理通知
        NSArray *allDelegates = self.delegateContainer.allObjects;
        for (id <CTLLocationManagerDelegate> delegate in allDelegates) {
            if (delegate && [delegate respondsToSelector:@selector(locationManager:didUpdateLocation:)]) {
                [delegate locationManager:self didUpdateLocation:self.lastLocation];
            }
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // 代理通知
    self.locationState = CTLLocationStateFailure;
    [self stopUpdatingLocation];
    NSArray *allDelegates = self.delegateContainer.allObjects;
    for (id <CTLLocationManagerDelegate> delegate in allDelegates) {
        if (delegate && [delegate respondsToSelector:@selector(locationManager:didFailWithError:)]) {
            [delegate locationManager:self didFailWithError:error];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusNotDetermined) {
        [self requestLocationAuthorizationWhenInUse];
    } else {
        [NSNotificationCenter.defaultCenter postNotificationName:CTLLocationAuthorizationStatusDidChangeNotification
                                                          object:nil
                                                        userInfo:nil];
        if (!self.lastLocation && status != kCLAuthorizationStatusRestricted && status != kCLAuthorizationStatusDenied) {
            [self startUpdatingLocation];
        }
    }
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
        [NSUserDefaults.standardUserDefaults synchronize];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [NSUserDefaults.standardUserDefaults setObject:languages forKey:@"AppleLanguages"];
            [strongSelf reverseGeocodeLocation:location placemarks:placemarks error:error];
        }];
    }
}

- (void)reverseGeocodeLocation:(CLLocation *)location placemarks:(NSArray<CLPlacemark *> *)placemarks error:(NSError *)error {
    self.locationState = CTLLocationStateReverseGeocodingCompletion;
    
    if (!error && placemarks.count > 0) {
        CLPlacemark *place = placemarks.lastObject;
        self.lastLocationInfo = [CTLLocationInfo locationInfoWithLocation:location placemark:place];
    }
    
    // 代理通知
    NSArray *allDelegates = self.delegateContainer.allObjects;
    for (id <CTLLocationManagerDelegate> delegate in allDelegates) {
        if (delegate && [delegate respondsToSelector:@selector(locationManager:reverseGeocodeLocation:error:)]) {
            [delegate locationManager:self reverseGeocodeLocation:self.lastLocationInfo error:error];
        }
    }
}

@end

