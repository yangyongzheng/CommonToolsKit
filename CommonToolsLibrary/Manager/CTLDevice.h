//
//  CTLDevice.h
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/11/5.
//  Copyright © 2018 yangyongzheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CTLDevice : NSObject
// 获取单例
@property(class, nonatomic, readonly) CTLDevice *currentDevice;
// 版本判断
@property (nonatomic, readonly) BOOL isiOS8Later;
@property (nonatomic, readonly) BOOL isiOS9Later;
@property (nonatomic, readonly) BOOL isiOS10Later;
@property (nonatomic, readonly) BOOL isiOS11Later;
@property (nonatomic, readonly) BOOL isiOS12Later;

@end

NS_ASSUME_NONNULL_END
