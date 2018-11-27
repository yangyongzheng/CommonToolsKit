//
//  CTLLocationManager.h
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/11/27.
//  Copyright © 2018 yangyongzheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CTLLocationManager : NSObject
@property (class, nonatomic, readonly, strong) CTLLocationManager *defaultManager;

- (void)startLocation;
@end

NS_ASSUME_NONNULL_END
