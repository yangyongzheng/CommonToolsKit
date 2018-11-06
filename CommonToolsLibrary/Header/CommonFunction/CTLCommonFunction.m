//
//  CTLCommonFunction.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/11/6.
//  Copyright © 2018 yangyongzheng. All rights reserved.
//

#import "CTLCommonFunction.h"

BOOL CTLSystemVersionEqualTo(NSString *version) {
    return CTLCompareVersion(UIDevice.currentDevice.systemVersion, version) == NSOrderedSame;
}

BOOL CTLSystemVersionGreaterThan(NSString *version) {
    return CTLCompareVersion(UIDevice.currentDevice.systemVersion, version) == NSOrderedDescending;
}

BOOL CTLSystemVersionGreaterThanOrEqualTo(NSString *version) {
    return CTLCompareVersion(UIDevice.currentDevice.systemVersion, version) != NSOrderedAscending;
}

BOOL CTLSystemVersionLessThan(NSString *version) {
    return CTLCompareVersion(UIDevice.currentDevice.systemVersion, version) == NSOrderedAscending;
}

BOOL CTLSystemVersionLessThanOrEqualTo(NSString *version) {
    return CTLCompareVersion(UIDevice.currentDevice.systemVersion, version) != NSOrderedDescending;
}
