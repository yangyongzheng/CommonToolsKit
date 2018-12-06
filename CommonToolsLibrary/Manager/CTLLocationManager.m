//
//  CTLLocationManager.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/11/27.
//  Copyright © 2018 yangyongzheng. All rights reserved.
//

#import "CTLLocationManager.h"

@implementation CTLLocationInfo

+ (instancetype)locationInfoWithLocation:(CLLocation *)location placemark:(CLPlacemark *)placemark {
    CTLLocationInfo *info = [[CTLLocationInfo alloc] init];
    info.location = location;
    info.placemark = placemark;
    
    return info;
}

#pragma mark getter or setter
- (CLLocationDegrees)latitude {
    return _location.coordinate.latitude;
}

- (CLLocationDegrees)longitude {
    return _location.coordinate.longitude;
}

- (NSString *)country {
    return _placemark.country ?: @"";
}

- (NSString *)province {
    return _placemark.administrativeArea ?: @"";
}

- (NSString *)city {
    return  _placemark.locality ?: @"";
}

- (NSString *)district {
    return _placemark.subLocality ?: @"";
}

- (NSString *)street {
    return _placemark.thoroughfare ?: @"";
}

- (NSString *)landmark {
    return _placemark.name ?: @"";
}

// extra
- (NSString *)shortAddress {
    NSString *address = [NSString stringWithFormat:@"%@ %@", self.province, self.city];
    return [address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] ?: @"";
}

- (NSString *)mediumAddress {
    NSString *address = [NSString stringWithFormat:@"%@ %@", self.shortAddress, self.district];
    return [address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] ?: @"";
}

- (NSString *)longAddress {
    NSString *address = [NSString stringWithFormat:@"%@ %@", self.mediumAddress, self.street];
    return [address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] ?: @"";
}

- (NSString *)fullAddress {
    NSString *address = [NSString stringWithFormat:@"%@ %@", self.longAddress, self.landmark];
    return [address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] ?: @"";
}

@end


#pragma mark - 定位管理类
@interface CTLLocationManager ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geocoder;
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

- (CLGeocoder *)geocoder {
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
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
    BOOL enabled = self.locationState != CTLLocationStateSuccess || self.locationState != CTLLocationStateReverseGeocodingCompletion;
    if (locations.count > 0 && enabled) {
        self.locationState = CTLLocationStateSuccess;
        [self stopUpdatingLocation];
        _lastLocation = locations.lastObject;
        [self requestReverseGeocodeLocation:_lastLocation];
        
        // 代理通知
        for (id <CTLLocationManagerDelegate> delegate in self.delegateContainer) {
            if (delegate && [delegate respondsToSelector:@selector(locationManager:didUpdateLocation:)]) {
                [delegate locationManager:self didUpdateLocation:self.lastLocation];
            }
        }
        
        NSLog(@"did update %f-%f", self.lastLocation.coordinate.longitude, self.lastLocation.coordinate.latitude);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // 代理通知
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
}

#pragma mark - Misc
#pragma mark 请求反地理编码
- (void)requestReverseGeocodeLocation:(CLLocation *)location {
    __weak typeof(self) weakSelf = self;
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!error && placemarks.count > 0) {
            CLPlacemark *place = placemarks.lastObject;
            strongSelf->_lastLocationInfo = [CTLLocationInfo locationInfoWithLocation:location placemark:place];
            
            // 代理通知
            for (id <CTLLocationManagerDelegate> delegate in strongSelf.delegateContainer) {
                if (delegate && [delegate respondsToSelector:@selector(locationManager:reverseGeocodeLocation:error:)]) {
                    [delegate locationManager:strongSelf reverseGeocodeLocation:strongSelf.lastLocationInfo error:nil];
                }
            }
        }
    }];
}

@end

