//
//  NSTimer+CTLBlockTimer.h
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/10/13.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (CTLBlockTimer)

/**
 定时器，在interval秒后触发回调, RunLoop Mode为NSRunLoopCommonModes
 注意循环引用, 非主线程调用时需要开启当前RunLoop，并且只能在当前线程停止定时器（哪个线程开启，就在对应线程停止）。
 
 @param interval 触发间隔
 @param repeats 是否重复触发
 @param block 触发回调block
 @return 定时器
 */
+ (NSTimer *)ctl_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                        repeats:(BOOL)repeats
                                          block:(void (^)(NSTimer *timer))block;

/**
 倒计时定时器，在interval秒后触发回调, RunLoop Mode为NSRunLoopCommonModes
 注意循环引用, 非主线程调用时需要开启当前RunLoop，并且只能在当前线程停止定时器（哪个线程开启，就在对应线程停止）。
 
 @param countdownDuration 倒计时长
 @param interval 倒计时间隔，如果小于或等于0，则该方法选择0.1毫秒的非负值，然后判断是否小于等于倒计时长。
 @param block block回调
 @return 定时器
 */
+ (NSTimer *)ctl_scheduledTimerWithCountdownDuration:(NSTimeInterval)countdownDuration
                                            interval:(NSTimeInterval)interval
                                               block:(void(^)(NSTimer *timer, NSTimeInterval currentCountdown))block;

@end

NS_ASSUME_NONNULL_END
