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

@interface CTLCallMonitor ()<CXCallObserverDelegate>
@property (nonatomic, strong) CTCallCenter *callCenter NS_DEPRECATED_IOS(4_0, 10_0, "Please use callObserver instead");
@property (nonatomic, strong) CXCallObserver *callObserver NS_AVAILABLE_IOS(10_0);
@property (nonatomic, weak) id<CTLCallMonitorDelegate> callDelegate;
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

- (void)startMonitorWithDelegate:(id<CTLCallMonitorDelegate>)delegate {
    self.callDelegate = delegate;
    if (@available(iOS 10.0, *)) {
        [self.callObserver setDelegate:self queue:nil];
    } else {
        self.callCenter.callEventHandler = ^(CTCall * _Nonnull call) {
            if ([call.callState isEqualToString:CTCallStateDialing]) {
                NSLog(@"正在呼叫");
            } else if ([call.callState isEqualToString:CTCallStateIncoming]) {
                NSLog(@"电话呼入");
            } else if ([call.callState isEqualToString:CTCallStateDisconnected]) {
                NSLog(@"挂断");
            } else if ([call.callState isEqualToString:CTCallStateConnected]) {
                NSLog(@"接通");
            }
        };
    }
}

#pragma mark - CXCallObserverDelegate
- (void)callObserver:(CXCallObserver *)callObserver callChanged:(CXCall *)call API_AVAILABLE(ios(10.0)) {
    NSString *prefix = nil;
    if (call.isOutgoing) {  // 呼出
        prefix = @"主叫方";
    } else {                // 呼入
        prefix = @"被叫方";
    }
    
    NSString *operationString = nil;
    if (call.hasEnded) {
        if (call.hasConnected) {
            NSLog(@"挂断");
        } else {
            NSLog(@"呼叫超时");
        }
    } else {
        if (call.hasConnected) {
            NSLog(@"接通");
        } else {
            NSLog(@"正在呼叫");
        }
    }
}

@end
