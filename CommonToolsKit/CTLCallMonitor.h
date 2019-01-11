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
@property (nonatomic) BOOL isCaller;
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
