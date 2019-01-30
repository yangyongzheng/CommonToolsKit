//
//  CTLCallMonitor.h
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/12/29.
//  Copyright © 2018 yangyongzheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CTLCallState) {
    CTLCallStateConnecting,     // 正在连接中
    CTLCallStateConnected,      // 连接成功
    CTLCallStateTimeout,        // 呼叫/接听超时
    CTLCallStateHungup,         // 挂断
};

@interface CTLCallInfo : NSObject
@property (nonatomic) BOOL isCaller;            // 自己是否是主叫方
@property (nonatomic) CTLCallState callState;   // 呼叫状态
@property (nonatomic, readonly, assign, getter=isOutgoing) BOOL outgoing;
@property (nonatomic, readonly, assign, getter=isOnHold) BOOL onHold;
@property (nonatomic, readonly, assign) BOOL hasConnected;
@property (nonatomic, readonly, assign) BOOL hasEnded;
@end


@class CTLCallMonitor;

@protocol CTLCallMonitorDelegate <NSObject>
- (void)callMonitor:(CTLCallMonitor *)callMonitor callChanged:(CTLCallInfo *)callInfo;
@end

@interface CTLCallMonitor : NSObject
@property (class, nonatomic, readonly, strong) CTLCallMonitor *callMonitor; // 非单例
- (void)startMonitorWithDelegate:(id<CTLCallMonitorDelegate>)delegate;;     // 开始监听
@end

NS_ASSUME_NONNULL_END
