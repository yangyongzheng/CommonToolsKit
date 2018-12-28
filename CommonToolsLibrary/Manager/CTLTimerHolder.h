//
//  CTLTimerHolder.h
//  CommonToolsKit
//
//  Created by 杨永正 on 2018/12/27.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CTLTimerHolder : NSObject

/**
 启动常规定时器

 @param interval 间隔时间
 @param repeats 是否重复
 @param block 事件回调block，注意循环引用
 */
- (void)startTimerWithTimeInterval:(NSTimeInterval)interval
                           repeats:(BOOL)repeats
                             block:(void(^)(CTLTimerHolder *timerHolder))block;

- (void)startTimerWithTimeInterval:(NSTimeInterval)interval
                           repeats:(BOOL)repeats
                              mode:(NSRunLoopMode)mode
                             block:(void(^)(CTLTimerHolder *timerHolder))block;

/**
 启动倒计时定时器, 倒计时总时长和间隔时间要能整除，否则最后一次倒计时会有较大误差。

 @param countdown 倒计时总时长
 @param interval 间隔
 @param block 事件回调block，注意循环引用
 */
- (void)startTimerWithCountdown:(NSTimeInterval)countdown
                       interval:(NSTimeInterval)interval
                          block:(void(^)(CTLTimerHolder *timerHolder, NSTimeInterval currentCountdown))block;

- (void)startTimerWithCountdown:(NSTimeInterval)countdown
                       interval:(NSTimeInterval)interval
                           mode:(NSRunLoopMode)mode
                          block:(void(^)(CTLTimerHolder *timerHolder, NSTimeInterval currentCountdown))block;

// 立即发送一次定时器事件回调
- (void)startFire;
// 停止定时器
- (void)stopTimer;

@end

NS_ASSUME_NONNULL_END
