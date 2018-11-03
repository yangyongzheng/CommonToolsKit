//
//  NSString+CTLURLComparison.h
//  CommonToolsKit
//
//  Created by 杨永正 on 2018/11/3.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CTLURLComparison)

/** 忽略URL Query部分进行比较 */
- (BOOL)ctl_compareURLStringIgnoreQueryComponent:(NSString *)aURLString;

/** 忽略URL Scheme和Query部分进行比较
 注：以http://开头的URL转化为https://后进行比较
 */
- (BOOL)ctl_compareURLStringIgnoreSchemeAndQueryComponents:(NSString *)aURLString;

/** 格式化URL地址(去掉URL Query部分) */
- (NSString *)ctl_formatURLStringIgnoreQueryComponent;

@end

NS_ASSUME_NONNULL_END
