//
//  CTLDevice.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/11/5.
//  Copyright © 2018 yangyongzheng. All rights reserved.
//

#import "CTLDevice.h"
#import <sys/utsname.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@interface CTLDevice ()
@property (nonatomic, readonly) UIEdgeInsets safeAreaInsets;
@end

@implementation CTLDevice

+ (CTLDevice *)currentDevice {
    static CTLDevice *device = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        device = [[CTLDevice alloc] init];
        [device loadDefaultConfiguration];
    });
    
    return device;
}

- (void)loadDefaultConfiguration {
    UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        UIWindow *tmpWindow = UIApplication.sharedApplication.keyWindow;
        if (!tmpWindow) {
            tmpWindow = UIApplication.sharedApplication.windows.firstObject;
        }
        safeAreaInsets = tmpWindow.safeAreaInsets;
    }
    
    self->_hasBangs = safeAreaInsets.bottom > 20;// 横向时 有刘海设备的bottomMargin为 21.0
    self->_safeAreaInsets = safeAreaInsets;
}

- (NSString *)deviceModelIdentifier {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

- (NSString *)SIMOperator {
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = networkInfo.subscriberCellularProvider;
    return carrier.carrierName;
}

- (CGSize)screenResolution {
    CGSize size = UIScreen.mainScreen.bounds.size;
    CGFloat scale = UIScreen.mainScreen.scale;
    return CGSizeMake(size.width * scale,
                      size.height * scale);
}

- (CGFloat)additionalSafeAreaBottomMargin {
    return self.safeAreaInsets.bottom;
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
