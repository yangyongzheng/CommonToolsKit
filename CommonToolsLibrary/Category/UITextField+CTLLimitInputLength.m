//
//  UITextField+CTLLimitInputLength.m
//  CommonToolsKit
//
//  Created by 杨永正 on 2018/11/4.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import "UITextField+CTLLimitInputLength.h"
#import <objc/runtime.h>

static const void * CTLInputMaxLengthAssociationKey = (void *)&CTLInputMaxLengthAssociationKey;

@implementation UITextField (CTLLimitInputLength)

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

#pragma mark 检查和过滤超限文字(忽略标记部分)
- (BOOL)ctl_filterTextBeyondLimitIgnoreMarked {
    BOOL beyondLimits = NO;
    NSUInteger maxLengthOfInputLimit =  [self ctl_inputMaxLength];
    if (maxLengthOfInputLimit > 0) {
        NSString *currentText = self.text;
        // 获取高亮部分
        UITextRange *markedTextRange = [self markedTextRange];
        UITextPosition *position = [self positionFromPosition:markedTextRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行过滤
        if (!position) {
            if (currentText.length > maxLengthOfInputLimit) {
                beyondLimits = YES;
                NSRange rangeIndex = [currentText rangeOfComposedCharacterSequenceAtIndex:maxLengthOfInputLimit];
                if (rangeIndex.length == 1) {// 长度为1直接切割，否则临界点字符整个切割
                    self.text = [currentText substringToIndex:maxLengthOfInputLimit];
                } else {
                    self.text = [currentText substringToIndex:rangeIndex.location];
                }
            }
        }
    }
    
    return beyondLimits;
}

@end
