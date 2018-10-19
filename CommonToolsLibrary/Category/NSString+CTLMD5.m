//
//  NSString+CTLMD5.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/10/19.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import "NSString+CTLMD5.h"
#import <CommonCrypto/CommonDigest.h>

static NSString * const CTLMD5Salt = @"BE4D$3D9F-EF%15-47E*4-98/69-6962(3CBE$DA6C 7C3@B%AC8-5*26C-4D.92-BB|F3-479～A6%6438E3B C1&D54B5B-1B^CE-41=D1-81+F3-D6%@449D982297";

@implementation NSString (CTLMD5)

@dynamic ctl_MD5;

- (NSString *)ctl_MD5 {
    const char *cStr = self.UTF8String;
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02X", digest[i]];
    }
    
    return [output copy];
}

- (NSString *)ctl_addSalt {
    return [NSString stringWithFormat:@"%@-%@-%@", CTLMD5Salt, self, CTLMD5Salt];
}

@end
