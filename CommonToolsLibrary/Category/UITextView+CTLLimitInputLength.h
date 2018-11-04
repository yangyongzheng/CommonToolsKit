//
//  UITextView+CTLLimitInputLength.h
//  CommonToolsKit
//
//  Created by 杨永正 on 2018/11/4.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (CTLLimitInputLength)

/**
 输入的最大长度，0为不限制，可在代理方法`textViewDidBeginEditing:`中设置
 */
@property (nonatomic) NSUInteger ctl_inputMaxLength;

/**
 检查和过滤超限文字(忽略标记部分)，可在代理方法`textViewDidChange:`中调用
 
 @return 输入文字超限时返回YES，否则返回NO
 */
- (BOOL)ctl_filterTextBeyondLimitIgnoreMarked;

@end

NS_ASSUME_NONNULL_END
