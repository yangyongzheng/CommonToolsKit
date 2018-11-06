//
//  NSString+CTLURLComparison.m
//  CommonToolsKit
//
//  Created by 杨永正 on 2018/11/3.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import "NSString+CTLURLComparison.h"
#import "CTLCommonFunction.h"

@implementation NSString (CTLURLComparison)

#pragma mark - URLString获取和比较
#pragma mark 忽略URL Query部分进行比较
- (BOOL)ctl_compareURLStringIgnoreQueryComponent:(NSString *)aURLString {
    if (CTLAssertStringNotEmpty(self) && CTLAssertStringNotEmpty(aURLString)) {
        NSString *fromURLString = [self ctl_formatURLStringEndCharacterIgnoreQueryComponent];
        NSString *toURLString = [aURLString ctl_formatURLStringEndCharacterIgnoreQueryComponent];
        return [fromURLString isEqualToString:toURLString];
    } else {
        return NO;
    }
}

#pragma mark 忽略URL Scheme和Query部分进行比较
- (BOOL)ctl_compareURLStringIgnoreSchemeAndQueryComponents:(NSString *)aURLString {
    if (CTLAssertStringNotEmpty(self) && CTLAssertStringNotEmpty(aURLString)) {
        NSString *fromURLString = [[self ctl_formatURLStringEndCharacterIgnoreQueryComponent] ctl_formatURLStringSchemeHttpToHttps];
        NSString *toURLString = [[aURLString ctl_formatURLStringEndCharacterIgnoreQueryComponent] ctl_formatURLStringSchemeHttpToHttps];
        return [fromURLString isEqualToString:toURLString];
    } else {
        return NO;
    }
}

#pragma mark 过滤URL Query部分格式化URLString
- (NSString *)ctl_formatURLStringIgnoreQueryComponent {
    if (CTLAssertStringNotEmpty(self)) {
        NSString *tempSelf = self;
        NSRange range = [self rangeOfString:@"?"];
        if (range.location != NSNotFound) {
            tempSelf = [self substringToIndex:range.location];
        }
        return tempSelf;
    } else {
        return nil;
    }
}

#pragma mark - Private Method
#pragma mark 过滤URL末尾字符'/'
- (NSString *)ctl_formatURLStringEndCharacterIgnoreQueryComponent {
    if (CTLAssertStringNotEmpty(self)) {
        NSString *filterURLString = [self ctl_formatURLStringIgnoreQueryComponent];
        if ([filterURLString hasSuffix:@"/"]) {// 是否以"/"字符结尾
            return [self substringToIndex:self.length-1];
        } else {
            return self;
        }
    } else {
        return nil;
    }
}

- (NSString *)ctl_formatURLStringSchemeHttpToHttps {
    NSString *tempSelf = self;
    if (CTLAssertStringNotEmpty(tempSelf)) {
        if ([tempSelf hasPrefix:@"http:"]) {
            tempSelf = [tempSelf stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:@"https:"];
        }
    }
    return tempSelf;
}

@end
