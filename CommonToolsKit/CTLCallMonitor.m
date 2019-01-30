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

@implementation CTLCallInfo

- (CTLCallInfo *)copyCallInfo {
    CTLCallInfo *tempCallInfo = [[CTLCallInfo alloc] init];
    tempCallInfo.isCaller = self.isCaller;
    tempCallInfo.callState = self.callState;
    return tempCallInfo;
}

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
        [self.callObserver setDelegate:self queue:nil];
    } else {
        __weak typeof(self) weakSelf = self;
        self.callCenter.callEventHandler = ^(CTCall * _Nonnull call) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if ([call.callState isEqualToString:CTCallStateDialing]) {
                strongSelf.callInfo.isCaller = YES;
                strongSelf.callInfo.callState = CTLCallStateConnecting;
            } else if ([call.callState isEqualToString:CTCallStateIncoming]) {
                strongSelf.callInfo.isCaller = NO;
                strongSelf.callInfo.callState = CTLCallStateConnecting;
            } else if ([call.callState isEqualToString:CTCallStateConnected]) {
                strongSelf.callInfo.callState = CTLCallStateConnected;
            } else if ([call.callState isEqualToString:CTCallStateDisconnected]) {
                strongSelf.callInfo.callState = CTLCallStateHungup;
            }
            
            void(^callChangedHandler)(void) = ^(void) {
                if (strongSelf.callDelegate && [strongSelf.callDelegate respondsToSelector:@selector(callMonitor:callChanged:)]) {
                    [strongSelf.callDelegate callMonitor:strongSelf callChanged:[strongSelf.callInfo copyCallInfo]];
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
    self.callInfo.isCaller = call.isOutgoing;
    if (call.hasEnded) {
        if (call.hasConnected) {
            self.callInfo.callState = CTLCallStateHungup;
        } else {
            self.callInfo.callState = CTLCallStateTimeout;
        }
    } else {
        if (call.hasConnected) {
            self.callInfo.callState = CTLCallStateConnected;
        } else {
            self.callInfo.callState = CTLCallStateConnecting;
        }
    }
}

@end
