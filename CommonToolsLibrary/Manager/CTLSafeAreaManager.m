//
//  CTLSafeAreaManager.m
//  Test
//
//  Created by yangyongzheng on 2018/11/1.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import "CTLSafeAreaManager.h"

@interface CTLSafeAreaManager ()
@property (nonatomic, readwrite) UIEdgeInsets safeAreaInsets;
@end

@implementation CTLSafeAreaManager

+ (CTLSafeAreaManager *)defaultManager {
    static CTLSafeAreaManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CTLSafeAreaManager alloc] init];
    });
    
    return manager;
}

- (void)startConfigurationWithKeyWindow:(UIWindow *)keyWindow {
    if (@available(iOS 11.0, *)) {
        self.safeAreaInsets = keyWindow.safeAreaInsets;
    } else {
        self.safeAreaInsets = UIEdgeInsetsMake(20, 0, 0, 0);
    }
}

- (CGFloat)navigationBarHeight {
    return 44.0f;
}

- (CGFloat)statusBarHeight {
    return UIApplication.sharedApplication.statusBarFrame.size.height;
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
