//
//  NSTimer+CTLBlockTimer.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/10/13.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import "NSTimer+CTLBlockTimer.h"
#import <objc/runtime.h>

@interface __CTLNormalTimerInfo : NSObject
@property (nonatomic, copy) void(^ctl_timerBlock)(NSTimer *timer);
@end

@implementation __CTLNormalTimerInfo

@end


@interface __CTLCountdownTimerInfo : NSObject
@property (nonatomic) NSTimeInterval ctl_countdownDuration;
@property (nonatomic) NSTimeInterval ctl_currentCountdown;
@property (nonatomic) NSTimeInterval ctl_interval;
@property (nonatomic, copy) void(^ctl_timerBlock)(NSTimer *timer, NSTimeInterval currentCountdown);
@end

@implementation __CTLCountdownTimerInfo

@end


@interface NSTimer ()
@property (nonatomic, strong) __CTLNormalTimerInfo *ctl_normalInfo;
@property (nonatomic, strong) __CTLCountdownTimerInfo *ctl_countdownInfo;
@end

static const void *ctl_normalInfoAssociationKey = (void *)&ctl_normalInfoAssociationKey;
static const void *ctl_countdownInfoAssociationKey = (void *)&ctl_countdownInfoAssociationKey;

@implementation NSTimer (CTLBlockTimer)

+ (NSTimer *)ctl_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                        repeats:(BOOL)repeats
                                          block:(void (^)(NSTimer * _Nonnull))block {
    NSTimer *timer = [NSTimer timerWithTimeInterval:interval
                                             target:self
                                           selector:@selector(ctl_normalTimerFireInvocation:)
                                           userInfo:nil
                                            repeats:repeats];
    timer.ctl_normalInfo = [[__CTLNormalTimerInfo alloc] init];
    timer.ctl_normalInfo.ctl_timerBlock = block ? [block copy] : nil;
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    return timer;
}

+ (NSTimer *)ctl_scheduledTimerWithCountdownDuration:(NSTimeInterval)countdownDuration
                                            interval:(NSTimeInterval)interval
                                               block:(void (^)(NSTimer * _Nonnull, NSTimeInterval))block {
    if (interval <= 0) {
        interval = 0.0001;
    }
    if (countdownDuration < interval) {
        return nil;
    } else {
        NSTimer *timer = [NSTimer timerWithTimeInterval:interval
                                                 target:self
                                               selector:@selector(ctl_countdownTimerFireInvocation:)
                                               userInfo:nil
                                                repeats:YES];
        timer.ctl_countdownInfo = [[__CTLCountdownTimerInfo alloc] init];
        timer.ctl_countdownInfo.ctl_countdownDuration = countdownDuration;
        timer.ctl_countdownInfo.ctl_interval = interval;
        timer.ctl_countdownInfo.ctl_currentCountdown = countdownDuration;
        timer.ctl_countdownInfo.ctl_timerBlock = block ? [block copy] : nil;
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        
        return timer;
    }
}

#pragma mark - Private Method
+ (void)ctl_normalTimerFireInvocation:(NSTimer *)timer {
    __CTLNormalTimerInfo *info = timer.ctl_normalInfo;
    if (info.ctl_timerBlock) {
        info.ctl_timerBlock(timer);
    } else {
        [timer invalidate];
    }
}

+ (void)ctl_countdownTimerFireInvocation:(NSTimer *)timer {
    __CTLCountdownTimerInfo *info = timer.ctl_countdownInfo;
    if (info.ctl_timerBlock) {
        NSTimeInterval currentCountdown = info.ctl_currentCountdown;
        NSTimeInterval interval = info.ctl_interval;
        info.ctl_currentCountdown = currentCountdown - interval;
        if (info.ctl_currentCountdown <= 0) {
            info.ctl_currentCountdown = 0;
            [timer invalidate];
        }
        info.ctl_timerBlock(timer, info.ctl_currentCountdown);
    } else {
        [timer invalidate];
    }
}

- (__CTLNormalTimerInfo *)ctl_normalInfo {
    return objc_getAssociatedObject(self, ctl_normalInfoAssociationKey);
}

- (void)setCtl_normalInfo:(__CTLNormalTimerInfo *)ctl_normalInfo {
    objc_setAssociatedObject(self,
                             ctl_normalInfoAssociationKey,
                             ctl_normalInfo,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (__CTLCountdownTimerInfo *)ctl_countdownInfo {
    return objc_getAssociatedObject(self, ctl_countdownInfoAssociationKey);
}

- (void)setCtl_countdownInfo:(__CTLCountdownTimerInfo *)ctl_countdownInfo {
    objc_setAssociatedObject(self,
                             ctl_countdownInfoAssociationKey,
                             ctl_countdownInfo,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
