//
//  CTLAppStatusMonitor.h
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/11/1.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CTLAppStatusMonitor;
@protocol CTLAppStatusMonitorDelegate <NSObject>
@optional
- (void)applicationDidFinishLaunching:(CTLAppStatusMonitor *)monitor;
- (void)applicationWillTerminate:(CTLAppStatusMonitor *)monitor;
- (void)applicationWillEnterForeground:(CTLAppStatusMonitor *)monitor;
- (void)applicationDidEnterBackground:(CTLAppStatusMonitor *)monitor;
- (void)applicationDidBecomeActive:(CTLAppStatusMonitor *)monitor;
- (void)applicationWillResignActive:(CTLAppStatusMonitor *)monitor;
- (void)applicationDidReceiveMemoryWarning:(CTLAppStatusMonitor *)monitor;
@end

@interface CTLAppStatusMonitor : NSObject
@property (class, nonatomic, readonly, strong) CTLAppStatusMonitor *defaultMonitor;// 获取单例
@property (nonatomic, readonly) BOOL isMonitoring;

- (void)startMonitor;
- (void)stopMonitor;

- (void)addDelegate:(id <CTLAppStatusMonitorDelegate>)delegate;
- (void)removeDelegate:(id <CTLAppStatusMonitorDelegate>)delegate;
@end

NS_ASSUME_NONNULL_END
