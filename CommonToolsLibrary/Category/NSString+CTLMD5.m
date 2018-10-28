//
//  NSString+CTLMD5.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/10/19.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import "NSString+CTLMD5.h"
#import <CommonCrypto/CommonDigest.h>

static NSString * const CTLMD5Salt = @"&olVEkL7A736d,`D2I&/xd+2XVnwg:>_6^tLTH90+2ks<7p<,Qf5%W:(d2(2adVUjIrjL-u3DuZ&r)@R9+S'_'y1sS)lN|EuhQBDd?o=PXhc6^a-EAXJhhiotR/5(d4>?tWCCf(P:'F0DTXIPNspj*dkHe)c``/B5+`:c_l>#)XH!0*e=2Y!DuK%ikZCmOi9FxUcU~UZ;<`S~gN|Z>$(?=kWItN_D5&4~%Ik7k.kL'!<ceaqS!xo:=>|V!_DeM>9";

@implementation NSString (CTLMD5)

@dynamic ctl_MD5, ctl_MD5AddSalt;

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

- (NSString *)ctl_MD5AddSalt {
    NSString *md5 = self.ctl_MD5;
    NSMutableString *result = [NSMutableString string];
    
    int j = 0;
    for (int i = 0; i < CTLMD5Salt.length; i+=8) {// 盐值256位
        [result appendString:[CTLMD5Salt substringWithRange:NSMakeRange(i, 8)]];
        [result appendString:[md5 substringWithRange:NSMakeRange(j, 1)]];
        j++;
    }
    
    return result.ctl_MD5;
}

@end
