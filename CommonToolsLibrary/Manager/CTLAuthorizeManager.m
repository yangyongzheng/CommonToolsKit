//
//  CTLAuthorizeManager.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/11/26.
//  Copyright © 2018 yangyongzheng. All rights reserved.
//

#import "CTLAuthorizeManager.h"
#import "CTLCommonFunction.h"
#import <Photos/Photos.h>
#import <CoreLocation/CoreLocation.h>

@implementation CTLAuthorizeManager

#pragma mark - 相册/相机
+ (CTLPHAuthorizationStatus)albumAuthorizationStatus {
    return (CTLPHAuthorizationStatus)[PHPhotoLibrary authorizationStatus];
}

+ (CTLPHAuthorizationStatus)cameraAuthorizationStatus {
    CTLPHAuthorizationStatus authorizationStatus;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        authorizationStatus = (CTLPHAuthorizationStatus)[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    } else {
        authorizationStatus = CTLPHAuthorizationStatusRestricted;
    }
    
    return authorizationStatus;
}

+ (void)requestAlbumAuthorization:(void (^)(CTLPHAuthorizationStatus))resultHandler {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        CTLSafeSyncMainQueueHandler(^{
            if (resultHandler) {
                resultHandler((CTLPHAuthorizationStatus)status);
            }
        });
    }];
}

+ (void)requestCameraAccessAuthorization:(void (^)(CTLPHAuthorizationStatus))resultHandler {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        CTLSafeSyncMainQueueHandler(^{
            if (resultHandler) {
                if (granted) {
                    resultHandler(CTLPHAuthorizationStatusAuthorized);
                } else {
                    resultHandler(CTLPHAuthorizationStatusDenied);
                }
            }
        });
    }];
}

#pragma mark - 用户定位信息
+ (CTLLocationAuthorizationStatus)locationAuthorizationStatus {
    if ([CLLocationManager locationServicesEnabled]) {
        return (CTLLocationAuthorizationStatus)[CLLocationManager authorizationStatus];
    } else {
        return CTLLocationAuthorizationStatusServicesDisabled;
    }
}

+ (void)requestLocationAuthorizationWhenInUse {
    [[CLLocationManager alloc] init];
}

+ (void)requestLocationAuthorizationAlways {
    
}

@end
