//
//  UISearchBar+CTLLimitInputLength.m
//  CommonToolsKit
//
//  Created by 杨永正 on 2018/11/4.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import "UISearchBar+CTLLimitInputLength.h"
#import <objc/runtime.h>

static const void * CTLInputMaxLengthAssociationKey = (void *)&CTLInputMaxLengthAssociationKey;

@implementation UISearchBar (CTLLimitInputLength)

@dynamic ctl_inputMaxLength;

- (void)setCtl_inputMaxLength:(NSUInteger)ctl_inputMaxLength {
    if (ctl_inputMaxLength > 0) {
        NSNumber *number = [NSNumber numberWithUnsignedInteger:ctl_inputMaxLength];
        objc_setAssociatedObject(self, CTLInputMaxLengthAssociationKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else {
        objc_setAssociatedObject(self, CTLInputMaxLengthAssociationKey, nil, OBJC_ASSOCIATION_ASSIGN);
    }
}

- (NSUInteger)ctl_inputMaxLength {
    NSNumber *number = objc_getAssociatedObject(self, CTLInputMaxLengthAssociationKey);
    return [number unsignedIntegerValue];
}

- (BOOL)filterTextBeyondLimit {
    BOOL beyondLimits;
    [self filterTextBeyondLimit:&beyondLimits result:nil];
    return beyondLimits;
}

- (NSString *)filterTextToLimitMaxLength {
    NSString *reslut;
    [self filterTextBeyondLimit:nil result:&reslut];
    return reslut;
}

- (void)filterTextBeyondLimit:(BOOL *)isBeyond result:(NSString **)result {
    // 初始化
    if (isBeyond) {*isBeyond = NO;}
    if (result) {*result = self.text;}
    // 判断
    NSUInteger maxLengthOfInputLimit =  [self ctl_inputMaxLength];
    if (maxLengthOfInputLimit > 0) {
        NSString *currentText = self.text;
        // 对已输入的文字进行过滤
        if (currentText.length > maxLengthOfInputLimit) {
            if (isBeyond) {*isBeyond = YES;}
            NSRange rangeIndex = [currentText rangeOfComposedCharacterSequenceAtIndex:maxLengthOfInputLimit];
            if (rangeIndex.length == 1) {// 长度为1直接切割，否则临界点字符整个切割
                self.text = [currentText substringToIndex:maxLengthOfInputLimit];
            } else {
                self.text = [currentText substringToIndex:rangeIndex.location];
            }
            if (result) {*result = self.text;}
        }
    }
}

@end
