//
//  CTLTimerHolder.m
//  CommonToolsKit
//
//  Created by 杨永正 on 2018/12/27.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import "CTLTimerHolder.h"
#import <objc/runtime.h>

@interface NSTimer (CTLTimerHolder)
@property (nonatomic, copy) void(^NSTimerCTLTimerHolderTimerBlock)(NSTimer *);

+ (NSTimer *)weak_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         repeats:(BOOL)repeats
                                            mode:(NSRunLoopMode)mode
                                           block:(void (^)(NSTimer *timer))block;
@end

@implementation NSTimer (CTLTimerHolder)

static const void * NSTimerCTLTimerHolderTimerBlockAssociationKey = (void *)&NSTimerCTLTimerHolderTimerBlockAssociationKey;

@dynamic NSTimerCTLTimerHolderTimerBlock;

- (void)setNSTimerCTLTimerHolderTimerBlock:(void (^)(NSTimer *))timerBlock {
    objc_setAssociatedObject(self,
                             NSTimerCTLTimerHolderTimerBlockAssociationKey,
                             timerBlock,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(NSTimer *))NSTimerCTLTimerHolderTimerBlock {
    return objc_getAssociatedObject(self, NSTimerCTLTimerHolderTimerBlockAssociationKey);
}

+ (NSTimer *)weak_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         repeats:(BOOL)repeats
                                            mode:(NSRunLoopMode)mode
                                           block:(void (^)(NSTimer *))block {
    if (interval <= 0) {
        interval = 0.0001;
    }
    NSTimer *timer = [NSTimer timerWithTimeInterval:interval
                                             target:self
                                           selector:@selector(private_weakTimerFiredInvoke:)
                                           userInfo:nil
                                            repeats:repeats];
    timer.NSTimerCTLTimerHolderTimerBlock = block?[block copy]:nil;
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:mode?:NSRunLoopCommonModes];
    return timer;
}

+ (void)private_weakTimerFiredInvoke:(NSTimer *)aTimer {
    void(^timerBlock)(NSTimer *) = aTimer.NSTimerCTLTimerHolderTimerBlock;
    if (timerBlock) {
        timerBlock(aTimer);
    } else {
        [aTimer invalidate];
    }
}

@end


@interface CTLTimerHolder ()
@property (nonatomic, strong) NSTimer *currentTimer;
@property (nonatomic, copy) void(^timerBlock)(CTLTimerHolder *);
@property (nonatomic, copy) void(^countdownTimerBlock)(CTLTimerHolder *, NSTimeInterval);
@property (nonatomic, assign) NSTimeInterval currentCountdown;
@end

@implementation CTLTimerHolder

#pragma mark - 常规定时器
- (void)startTimerWithTimeInterval:(NSTimeInterval)interval
                           repeats:(BOOL)repeats
                             block:(nonnull void (^)(CTLTimerHolder * _Nonnull))block {
    [self startTimerWithTimeInterval:interval
                             repeats:repeats
                                mode:NSRunLoopCommonModes
                               block:block];
}

- (void)startTimerWithTimeInterval:(NSTimeInterval)interval
                           repeats:(BOOL)repeats
                              mode:(NSRunLoopMode)mode
                             block:(void (^)(CTLTimerHolder * _Nonnull))block {
    if (self.currentTimer) {
        [self.currentTimer invalidate];
        self.currentTimer = nil;
    }
    self.timerBlock = block ? [block copy] : nil;
    
    __weak typeof(self) weakSelf = self;
    self.currentTimer = [NSTimer weak_scheduledTimerWithTimeInterval:interval repeats:repeats mode:mode block:^(NSTimer *timer) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            if (strongSelf.timerBlock) {
                strongSelf.timerBlock(strongSelf);
            }
            if (!repeats) {
                strongSelf.currentTimer = nil;
            }
        }
    }];
}

#pragma mark - 倒计时定时器
- (void)startTimerWithCountdown:(NSTimeInterval)countdown
                       interval:(NSTimeInterval)interval
                          block:(void (^)(CTLTimerHolder * _Nonnull, NSTimeInterval))block {
    [self startTimerWithCountdown:countdown
                         interval:interval
                             mode:NSRunLoopCommonModes
                            block:block];
}

- (void)startTimerWithCountdown:(NSTimeInterval)countdown
                       interval:(NSTimeInterval)interval
                           mode:(NSRunLoopMode)mode
                          block:(void (^)(CTLTimerHolder * _Nonnull, NSTimeInterval))block {
    if (self.currentTimer) {
        [self.currentTimer invalidate];
        self.currentTimer = nil;
    }
    self.countdownTimerBlock = block ? [block copy] : nil;
    self.currentCountdown = countdown;
    
    if (interval <= 0) {
        interval = 0.001;
    }
    if (countdown < interval) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    self.currentTimer = [NSTimer weak_scheduledTimerWithTimeInterval:interval repeats:YES mode:mode block:^(NSTimer *timer) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            strongSelf.currentCountdown -= interval;
            if (strongSelf.currentCountdown <= 0) {
                strongSelf.currentCountdown = 0;
                [strongSelf stopTimer];
            }
            if (strongSelf.countdownTimerBlock) {
                strongSelf.countdownTimerBlock(strongSelf, strongSelf.currentCountdown);
            }
        }
    }];
}

#pragma mark - 立即发送一次事件回调
- (void)startFire {
    if (self.currentTimer) {
        [self.currentTimer fire];
    }
}

#pragma mark - 停止定时器
- (void)stopTimer {
    if (self.currentTimer) {
        [self.currentTimer invalidate];
        self.currentTimer = nil;
    }
}

#pragma mark - Misc
- (void)dealloc {
    [self stopTimer];
}

@end
