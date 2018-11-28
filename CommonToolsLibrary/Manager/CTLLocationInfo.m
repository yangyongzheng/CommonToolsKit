//
//  CTLLocationInfo.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/11/28.
//  Copyright © 2018 yangyongzheng. All rights reserved.
//

#import "CTLLocationInfo.h"
#import <CoreLocation/CoreLocation.h>

@implementation CTLLocationInfo

+ (instancetype)locationInfoWithLocation:(CLLocation *)location placemark:(CLPlacemark *)placemark {
    CTLLocationInfo *info = [[CTLLocationInfo alloc] init];
    info.location = location;
    info.placemark = placemark;
    
    return info;
}

#pragma mark getter or setter
- (double)latitude {
    return _location.coordinate.latitude;
}

- (double)longitude {
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
