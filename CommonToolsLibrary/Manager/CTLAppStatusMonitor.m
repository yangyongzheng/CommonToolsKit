//
//  CTLAppStatusMonitor.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/11/1.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import "CTLAppStatusMonitor.h"
#import <UIKit/UIApplication.h>

@interface CTLAppStatusMonitor ()
@property (nonatomic, strong) NSHashTable *delegateContainer;
@property (nonatomic, readwrite) BOOL isMonitoring;
@end

@implementation CTLAppStatusMonitor

+ (CTLAppStatusMonitor *)defaultMonitor {
    static CTLAppStatusMonitor *monitor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        monitor = [[CTLAppStatusMonitor alloc] init];
    });
    
    return monitor;
}

- (void)dealloc {
    [self stopMonitor];
}

- (void)startMonitor {
    if (self.isMonitoring) {return;}
    self.isMonitoring = YES;
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(applicationDidFinishLaunchingNotification:)
                                               name:UIApplicationDidFinishLaunchingNotification
                                             object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(applicationWillTerminateNotification:)
                                               name:UIApplicationWillTerminateNotification
                                             object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(applicationWillEnterForegroundNotification:)
                                               name:UIApplicationWillEnterForegroundNotification
                                             object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(applicationDidEnterBackgroundNotification:)
                                               name:UIApplicationDidEnterBackgroundNotification
                                             object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(applicationDidBecomeActiveNotification:)
                                               name:UIApplicationDidBecomeActiveNotification
                                             object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(applicationWillResignActiveNotification:)
                                               name:UIApplicationWillResignActiveNotification
                                             object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(applicationDidReceiveMemoryWarningNotification:)
                                               name:UIApplicationDidReceiveMemoryWarningNotification
                                             object:nil];
}

- (void)stopMonitor {
    self.isMonitoring = NO;
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)addDelegate:(id<CTLAppStatusMonitorDelegate>)delegate {
    if (delegate) {[self.delegateContainer addObject:delegate];}
}

- (void)removeDelegate:(id<CTLAppStatusMonitorDelegate>)delegate {
    if (delegate) {[self.delegateContainer removeObject:delegate];}
}

#pragma mark - notifications
- (void)applicationDidFinishLaunchingNotification:(NSNotification *)notification {
    for (id <CTLAppStatusMonitorDelegate> delegate in self.delegateContainer) {
        if (delegate && [delegate respondsToSelector:@selector(applicationDidFinishLaunching:)]) {
            [delegate applicationDidFinishLaunching:self];
        }
    }
}

- (void)applicationWillTerminateNotification:(NSNotification *)notification {
    for (id <CTLAppStatusMonitorDelegate> delegate in self.delegateContainer) {
        if (delegate && [delegate respondsToSelector:@selector(applicationWillTerminate:)]) {
            [delegate applicationWillTerminate:self];
        }
    }
}

- (void)applicationWillEnterForegroundNotification:(NSNotification *)notification {
    for (id <CTLAppStatusMonitorDelegate> delegate in self.delegateContainer) {
        if (delegate && [delegate respondsToSelector:@selector(applicationWillEnterForeground:)]) {
            [delegate applicationWillEnterForeground:self];
        }
    }
}

- (void)applicationDidEnterBackgroundNotification:(NSNotification *)notification {
    for (id <CTLAppStatusMonitorDelegate> delegate in self.delegateContainer) {
        if (delegate && [delegate respondsToSelector:@selector(applicationDidEnterBackground:)]) {
            [delegate applicationDidEnterBackground:self];
        }
    }
}

- (void)applicationDidBecomeActiveNotification:(NSNotification *)notification {
    for (id <CTLAppStatusMonitorDelegate> delegate in self.delegateContainer) {
        if (delegate && [delegate respondsToSelector:@selector(applicationDidBecomeActive:)]) {
            [delegate applicationDidBecomeActive:self];
        }
    }
}

- (void)applicationWillResignActiveNotification:(NSNotification *)notification {
    for (id <CTLAppStatusMonitorDelegate> delegate in self.delegateContainer) {
        if (delegate && [delegate respondsToSelector:@selector(applicationWillResignActive:)]) {
            [delegate applicationWillResignActive:self];
        }
    }
}

- (void)applicationDidReceiveMemoryWarningNotification:(NSNotification *)notification {
    for (id <CTLAppStatusMonitorDelegate> delegate in self.delegateContainer) {
        if (delegate && [delegate respondsToSelector:@selector(applicationDidReceiveMemoryWarning:)]) {
            [delegate applicationDidReceiveMemoryWarning:self];
        }
    }
}

- (NSHashTable *)delegateContainer {
    if (!_delegateContainer) {
        _delegateContainer = [NSHashTable weakObjectsHashTable];
    }
    return _delegateContainer;
}

@end
