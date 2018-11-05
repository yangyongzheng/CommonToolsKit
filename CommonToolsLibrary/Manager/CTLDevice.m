//
//  CTLDevice.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/11/5.
//  Copyright © 2018 yangyongzheng. All rights reserved.
//

#import "CTLDevice.h"

@interface CTLDevice ()

@end

@implementation CTLDevice

+ (CTLDevice *)currentDevice {
    static CTLDevice *device = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        device = [[CTLDevice alloc] init];
    });
    
    return device;
}

- (BOOL)isiOS8Later {
    if (@available(iOS 8.0, *)) {
        return YES;
    }
    return NO;
}

- (BOOL)isiOS9Later {
    if (@available(iOS 9.0, *)) {
        return YES;
    }
    return NO;
}

- (BOOL)isiOS10Later {
    if (@available(iOS 10.0, *)) {
        return YES;
    }
    return NO;
}

- (BOOL)isiOS11Later {
    if (@available(iOS 11.0, *)) {
        return YES;
    }
    return NO;
}

- (BOOL)isiOS12Later {
    if (@available(iOS 12.0, *)) {
        return YES;
    }
    return NO;
}

@end
