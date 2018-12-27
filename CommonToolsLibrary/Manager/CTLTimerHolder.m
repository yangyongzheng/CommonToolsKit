//
//  CTLTimerHolder.m
//  CommonToolsKit
//
//  Created by 杨永正 on 2018/12/27.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import "CTLTimerHolder.h"
#import "NSTimer+CTLBlockTimer.h"

@interface CTLTimerHolder () {
    NSTimer *_currentTimer;
}
@end

@implementation CTLTimerHolder

- (void)startTimerWithTimeInterval:(NSTimeInterval)interval
                           repeats:(BOOL)repeats
                             block:(nonnull void (^)(CTLTimerHolder * _Nonnull))block {
    if (_currentTimer) {
        [_currentTimer invalidate];
        _currentTimer = nil;
    }
    
    __weak typeof(self) weakSelf = self;
    _currentTimer = [NSTimer ctl_scheduledTimerWithTimeInterval:interval
                                                        repeats:repeats
                                                          block:^(NSTimer * _Nonnull timer) {
                                                              __strong typeof(weakSelf) strongSelf = weakSelf;
                                                              if (block) {
                                                                  block(strongSelf);
                                                              }
                                                          }];
}

- (void)startTimerWithCountdown:(NSTimeInterval)countdown
                       interval:(NSTimeInterval)interval
                          block:(void (^)(CTLTimerHolder * _Nonnull, NSTimeInterval))block {
    if (_currentTimer) {
        [_currentTimer invalidate];
        _currentTimer = nil;
    }
    
    __weak typeof(self) weakSelf = self;
    _currentTimer = [NSTimer ctl_scheduledTimerWithCountdownDuration:countdown
                                                            interval:interval
                                                               block:^(NSTimer * _Nonnull timer, NSTimeInterval currentCountdown) {
                                                                   if (block) {
                                                                       block(weakSelf, currentCountdown);
                                                                   }
                                                               }];
}

- (void)startFire {
    if (_currentTimer) {
        [_currentTimer fire];
    }
}

- (void)stopTimer {
    if (_currentTimer) {
        [_currentTimer invalidate];
        _currentTimer = nil;
    }
}

#pragma mark - Misc
- (void)dealloc {
    [self stopTimer];
}

@end
