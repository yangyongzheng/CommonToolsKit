//
//  UIColor+CTLHelper.m
//  CommonToolsKit
//
//  Created by 杨永正 on 2018/11/4.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import "UIColor+CTLHelper.h"

@implementation UIColor (CTLHelper)

+ (instancetype)ctl_colorWithHexString:(NSString *)hexString {
    if (hexString && [hexString isKindOfClass:[NSString class]] && hexString.length > 0) {
        // 过滤空格以及换行符
        NSString *filterString = [hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].uppercaseString;
        filterString = [filterString stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (filterString.length >= 6) {
            if ([filterString hasPrefix:@"#"]) {
                filterString = [filterString substringFromIndex:1];
            } else if ([filterString hasPrefix:@"0X"]) {
                filterString = [filterString substringFromIndex:2];
            }
            if (filterString.length >= 6) {
                // 生成 r g b
                NSString *rString = [filterString substringWithRange:NSMakeRange(0, 2)];
                NSString *gString = [filterString substringWithRange:NSMakeRange(2, 2)];
                NSString *bString = [filterString substringWithRange:NSMakeRange(4, 2)];
                unsigned int r = 0, g = 0, b = 0;
                sscanf(rString.UTF8String, "%X", &r);
                sscanf(gString.UTF8String, "%X", &g);
                sscanf(bString.UTF8String, "%X", &b);
                
                return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
            }
        }
    }
    
    return [UIColor clearColor];
}

+ (instancetype)ctl_colorWithHexInt:(UInt32)hexNumber {
    if (hexNumber > 0xFFFFFF) { // 超范围转为字符串参数实例化方法
        NSString *hexString = [NSString stringWithFormat:@"%X", hexNumber];
        return [UIColor ctl_colorWithHexString:hexString];
    }
    
    NSInteger red = (hexNumber & 0xFF0000) >> 16;
    NSInteger green = (hexNumber & 0xFF00) >> 8;
    NSInteger blue = hexNumber & 0xFF;
    
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
}

+ (UIColor *)ctl_randomColor {
    NSInteger r = arc4random() % 256;
    NSInteger g = arc4random() % 256;
    NSInteger b = arc4random() % 256;
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}

@end
