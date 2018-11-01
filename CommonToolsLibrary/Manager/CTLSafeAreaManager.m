//
//  CTLSafeAreaManager.m
//  Test
//
//  Created by yangyongzheng on 2018/11/1.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import "CTLSafeAreaManager.h"

@interface CTLSafeAreaManager ()
@property (nonatomic, readwrite) BOOL hasBangs; // 是否有刘海
@property (nonatomic, readwrite) UIEdgeInsets safeAreaInsets;
@end

@implementation CTLSafeAreaManager

+ (CTLSafeAreaManager *)defaultManager {
    static CTLSafeAreaManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CTLSafeAreaManager alloc] init];
        [manager loadDefaultConfiguration];
    });
    
    return manager;
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
    self.hasBangs = safeAreaInsets.bottom > 20;
    self.safeAreaInsets = safeAreaInsets;
}

- (CGFloat)statusBarHeight {
    return UIApplication.sharedApplication.statusBarFrame.size.height;
}

- (CGFloat)navigationBarHeight {
    return 44.0f;
}

- (CGFloat)tabBarHeight {
    return 49.0f;
}

- (CGFloat)additionalSafeAreaBottomMargin {
    return self.safeAreaInsets.bottom;
}

- (CGFloat)safeAreaTopMargin {
    return self.statusBarHeight + self.navigationBarHeight;
}

- (CGFloat)safeAreaBottomMargin {
    return self.tabBarHeight + self.additionalSafeAreaBottomMargin;
}

@end
