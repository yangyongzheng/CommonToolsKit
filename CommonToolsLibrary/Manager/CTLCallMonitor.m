//
//  CTLCallMonitor.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/12/29.
//  Copyright © 2018 yangyongzheng. All rights reserved.
//

#import "CTLCallMonitor.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import <CallKit/CXCallObserver.h>
#import <CallKit/CXCall.h>

@interface CTLCallInfo ()
/** 是否是主叫方，YES-主叫方，NO-被叫方 */
@property (nonatomic, readwrite, getter=isOutgoing) BOOL outgoing;
/** 电话呼叫保持状态 */
@property (nonatomic, readwrite, getter=isOnHold) BOOL onHold;
/** 是否已接通 */
@property (nonatomic, readwrite) BOOL hasConnected;
/** 是否已挂断 */
@property (nonatomic, readwrite) BOOL hasEnded;
@end

@implementation CTLCallInfo

@end

@interface CTLCallMonitor ()<CXCallObserverDelegate>
@property (nonatomic, strong) CTCallCenter *callCenter NS_DEPRECATED_IOS(4_0, 10_0, "Please use callObserver instead");
@property (nonatomic, strong) CXCallObserver *callObserver NS_AVAILABLE_IOS(10_0);
@property (nonatomic, weak) id<CTLCallMonitorDelegate> callDelegate;
@property (nonatomic, strong) CTLCallInfo *callInfo;
@end

@implementation CTLCallMonitor

- (instancetype)init {
    self = [super init];
    if (self) {
        if (@available(iOS 10.0, *)) {
            self.callObserver = [[CXCallObserver alloc] init];
        } else {
            self.callCenter = [[CTCallCenter alloc] init];
        }
    }
    return self;
}

+ (CTLCallMonitor *)callMonitor {
    return [[CTLCallMonitor alloc] init];
}

- (CTLCallInfo *)callInfo {
    if (!_callInfo) {
        _callInfo = [[CTLCallInfo alloc] init];
    }
    return _callInfo;
}

- (void)startMonitorWithDelegate:(id<CTLCallMonitorDelegate>)delegate {
    self.callDelegate = delegate;
    if (@available(iOS 10.0, *)) {
        [self.callObserver setDelegate:self queue:dispatch_get_main_queue()];
    } else {
        __weak typeof(self) weakSelf = self;
        self.callCenter.callEventHandler = ^(CTCall * _Nonnull call) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if ([call.callState isEqualToString:CTCallStateDialing]) {
                strongSelf.callInfo.outgoing = YES;
                strongSelf.callInfo.onHold = NO;
                strongSelf.callInfo.hasConnected = NO;
                strongSelf.callInfo.hasEnded = NO;
            } else if ([call.callState isEqualToString:CTCallStateIncoming]) {
                strongSelf.callInfo.outgoing = NO;
                strongSelf.callInfo.onHold = NO;
                strongSelf.callInfo.hasConnected = NO;
                strongSelf.callInfo.hasEnded = NO;
            } else if ([call.callState isEqualToString:CTCallStateConnected]) {
                strongSelf.callInfo.hasConnected = YES;
                strongSelf.callInfo.hasEnded = NO;
            } else if ([call.callState isEqualToString:CTCallStateDisconnected]) {
                strongSelf.callInfo.hasEnded = YES;
            }
            
            void(^callChangedHandler)(void) = ^(void) {
                if (strongSelf.callDelegate && [strongSelf.callDelegate respondsToSelector:@selector(callMonitor:callChanged:)]) {
                    [strongSelf.callDelegate callMonitor:strongSelf callChanged:strongSelf.callInfo];
                }
            };
            
            if (NSThread.isMainThread) {
                callChangedHandler();
            } else {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    callChangedHandler();
                });
            }
        };
    }
}

#pragma mark - CXCallObserverDelegate
- (void)callObserver:(CXCallObserver *)callObserver callChanged:(CXCall *)call API_AVAILABLE(ios(10.0)) {
    self.callInfo.outgoing = call.isOutgoing;
    self.callInfo.onHold = call.onHold;
    self.callInfo.hasConnected = call.hasConnected;
    self.callInfo.hasEnded = call.hasEnded;
    
    if (self.callDelegate && [self.callDelegate respondsToSelector:@selector(callMonitor:callChanged:)]) {
        [self.callDelegate callMonitor:self callChanged:self.callInfo];
    }
}

@end
