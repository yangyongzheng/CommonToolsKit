//
//  UIColor+CTLHelper.h
//  CommonToolsKit
//
//  Created by 杨永正 on 2018/11/4.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (CTLHelper)

// 通过16进制字符串 创建UIColor对象，如 @"#66BB47", @"66BB47", @"0x66BB47", @"0X66BB47".
+ (instancetype)ctl_colorWithHexString:(NSString *)hexString;
// 通过16进制数 创建UIColor对象，如 @"0x66BB47", @"0X66BB47".
+ (instancetype)ctl_colorWithHexInt:(UInt32)hexNumber;
// 随机颜色
+ (UIColor *)ctl_randomColor;

@end

NS_ASSUME_NONNULL_END
