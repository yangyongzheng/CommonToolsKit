//
//  CTLSafeAreaManager.h
//  Test
//
//  Created by yangyongzheng on 2018/11/1.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CTLSafeAreaManager : NSObject
@property (class, nonatomic, readonly, strong) CTLSafeAreaManager *defaultManager;
@property (nonatomic, readonly) CGFloat navigationBarHeight;
@property (nonatomic, readonly) CGFloat statusBarHeight;
@property (nonatomic, readonly) CGFloat tabBarHeight;
@property (nonatomic, readonly) CGFloat additionalSafeAreaBottomMargin;
@property (nonatomic, readonly) CGFloat safeAreaTopMargin;
@property (nonatomic, readonly) CGFloat safeAreaBottomMargin;

- (void)startConfigurationWithKeyWindow:(UIWindow *)keyWindow;

@end

NS_ASSUME_NONNULL_END
