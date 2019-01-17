//
//  CTLCallMonitor.h
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/12/29.
//  Copyright © 2018 yangyongzheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CTLCallInfo : NSObject
/** 是否是主叫方，YES-主叫方，NO-被叫方 */
@property (nonatomic, readonly, getter=isOutgoing) BOOL outgoing;
/** 电话呼叫保持状态 */
@property (nonatomic, readonly, getter=isOnHold) BOOL onHold;
/** 是否已接通 */
@property (nonatomic, readonly) BOOL hasConnected;
/** 是否已挂断 */
@property (nonatomic, readonly) BOOL hasEnded;
@end

@class CTLCallMonitor;

@protocol CTLCallMonitorDelegate <NSObject>
- (void)callMonitor:(CTLCallMonitor *)callMonitor callChanged:(CTLCallInfo *)callInfo;
@end

@interface CTLCallMonitor : NSObject

/** 非单例 */
@property (class, nonatomic, readonly, strong) CTLCallMonitor *callMonitor;
/** 开始监听 */
- (void)startMonitorWithDelegate:(id<CTLCallMonitorDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
