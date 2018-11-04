//
//  UISearchBar+CTLLimitInputLength.h
//  CommonToolsKit
//
//  Created by 杨永正 on 2018/11/4.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UISearchBar (CTLLimitInputLength)

/**
 输入限制的最大长度，0为不限制，可在代理方法`searchBarTextDidBeginEditing:`中设置
 */
@property (nonatomic) NSUInteger ctl_inputMaxLength;

/**
 检查和过滤超限文字
 
 @return 输入文字已超限时返回YES，否则返回NO
 */
- (BOOL)filterTextBeyondLimit;

/**
 过滤超限文字并返回，可在代理方法`searchBar:textDidChange:`中调用
 
 @return 过滤超限文字后的内容
 */
- (NSString *)filterTextToLimitMaxLength;

@end

NS_ASSUME_NONNULL_END
