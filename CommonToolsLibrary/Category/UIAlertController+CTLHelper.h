//
//  UIAlertController+CTLHelper.h
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/10/13.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertActionItem : NSObject

+ (instancetype)actionItemWithTitle:(NSString *)title style:(UIAlertActionStyle)style;

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly) UIAlertActionStyle style;

@end


@interface UIAlertController (CTLHelper)

@property (nullable, nonatomic, copy) void(^alertActionHandler)(UIAlertAction *action);

/** `UIAlertActionStyle`使用默认值，按钮点击通过`alertActionHandler`block回调 */
+ (instancetype)alertControllerWithTitle:(nullable NSString *)title
                                 message:(nullable NSString *)message
                          preferredStyle:(UIAlertControllerStyle)preferredStyle
                       cancelActionTitle:(nullable NSString *)cancelActionTitle
                       otherActionTitles:(nullable NSArray<NSString *> *)otherActionTitles;

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title
                                 message:(nullable NSString *)message
                          preferredStyle:(UIAlertControllerStyle)preferredStyle
                       cancelActionTitle:(nullable NSString *)cancelActionTitle
                        otherActionTitle:(nullable NSString *)otherActionTitle, ... NS_REQUIRES_NIL_TERMINATION;

/** 可指定`UIAlertActionStyle`，按钮点击通过`alertActionHandler`block回调 */
+ (instancetype)alertControllerWithTitle:(nullable NSString *)title
                                 message:(nullable NSString *)message
                          preferredStyle:(UIAlertControllerStyle)preferredStyle
                             actionItems:(NSArray<UIAlertActionItem *> *)actionItems;

@end

NS_ASSUME_NONNULL_END
