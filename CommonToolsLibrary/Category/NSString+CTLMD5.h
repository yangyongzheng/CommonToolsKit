//
//  NSString+CTLMD5.h
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/10/19.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CTLMD5)
@property (nonatomic, readonly, copy) NSString *ctl_MD5;
@property (nonatomic, readonly, copy) NSString *ctl_MD5AddSalt;
@end

NS_ASSUME_NONNULL_END
