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
// 获取单例
@property (class, nonatomic, readonly, strong) CTLSafeAreaManager *defaultManager;
// 支持横竖屏
@property (nonatomic, readonly) BOOL hasBangs;  // 是否有刘海
// 只支持竖屏App
@property (nonatomic, readonly) CGFloat tabBarHeight;
@property (nonatomic, readonly) CGFloat navigationBarHeight;
@property (nonatomic, readonly) CGFloat statusBarHeight;
@property (nonatomic, readonly) CGFloat additionalSafeAreaBottomMargin;
@property (nonatomic, readonly) CGFloat safeAreaTopMargin;
@property (nonatomic, readonly) CGFloat safeAreaBottomMargin;
@end

NS_ASSUME_NONNULL_END
