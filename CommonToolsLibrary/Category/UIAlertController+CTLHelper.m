//
//  UIAlertController+CTLHelper.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/10/13.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import "UIAlertController+CTLHelper.h"
#import <objc/runtime.h>

@implementation UIAlertActionItem

+ (instancetype)actionItemWithTitle:(NSString *)title style:(UIAlertActionStyle)style {
    UIAlertActionItem *item = [[UIAlertActionItem alloc] init];
    item->_title = title;
    item->_style = style;
    return item;
}

@end


static const void * CTLAlertActionHandlerAssociationKey = (void *)&CTLAlertActionHandlerAssociationKey;

@implementation UIAlertController (CTLHelper)

@dynamic alertActionHandler;

#pragma mark - AssociatedObject
- (void (^)(UIAlertAction * _Nonnull))alertActionHandler {
    return objc_getAssociatedObject(self, CTLAlertActionHandlerAssociationKey);
}

- (void)setAlertActionHandler:(void (^)(UIAlertAction * _Nonnull))alertActionHandler {
    objc_setAssociatedObject(self,
                             CTLAlertActionHandlerAssociationKey,
                             alertActionHandler,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (instancetype)alertControllerWithTitle:(NSString *)title
                                 message:(NSString *)message
                          preferredStyle:(UIAlertControllerStyle)preferredStyle
                       cancelActionTitle:(NSString *)cancelActionTitle
                       otherActionTitles:(NSArray<NSString *> *)otherActionTitles {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:preferredStyle];
    // 添加 cancel action
    __weak typeof(alertController) weakSelf = alertController;
    if ([cancelActionTitle isKindOfClass:[NSString class]]) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelActionTitle
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 __strong typeof(weakSelf) strongSelf = weakSelf;
                                                                 if (strongSelf.alertActionHandler) {
                                                                     strongSelf.alertActionHandler(action);
                                                                 }
                                                             }];
        [alertController addAction:cancelAction];
    }
    // 添加 other Actions
    NSMutableArray *otherActions = [NSMutableArray arrayWithCapacity:otherActionTitles.count];
    for (id actionTitle in otherActionTitles) {
        NSString *tempActionTitle = nil;
        if ([actionTitle isKindOfClass:[NSString class]]) {
            tempActionTitle = actionTitle;
        } else if ([actionTitle respondsToSelector:@selector(stringValue)]) {
            tempActionTitle = [actionTitle stringValue];
        } else {
            NSAssert(NO, @"otherActionTitles 数组元素必须为 NSString 类型");
        }
        if (tempActionTitle) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:tempActionTitle
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               __strong typeof(weakSelf) strongSelf = weakSelf;
                                                               if (strongSelf.alertActionHandler) {
                                                                   strongSelf.alertActionHandler(action);
                                                               }
                                                           }];
            if (action) {[otherActions addObject:action];}
        }
    }
    for (UIAlertAction *action in otherActions) {
        [alertController addAction:action];
    }
    
    return alertController;
}

+ (instancetype)alertControllerWithTitle:(NSString *)title
                                 message:(NSString *)message
                          preferredStyle:(UIAlertControllerStyle)preferredStyle
                       cancelActionTitle:(NSString *)cancelActionTitle
                        otherActionTitle:(NSString *)otherActionTitle, ... {
    // 获取otherActionTitles参数表
    NSMutableArray *otherTitles = [NSMutableArray array];
    if (otherActionTitle) {
        [otherTitles addObject:otherActionTitle];
        
        va_list argList;                        // 定义一个 va_list 指针来访问参数表
        va_start(argList, otherActionTitle);    // 初始化 va_list，让它指向第一个变参，otherActionTitle 这里是第一个参数。
        id arg;
        while ((arg = va_arg(argList, id))) {   // 调用 va_arg 依次取出参数，它会自带指向下一个参数
            if ([arg isKindOfClass:[NSString class]]) {
                [otherTitles addObject:arg];
            } else if ([arg respondsToSelector:@selector(stringValue)]) {
                NSString *argString = [arg stringValue];
                if (argString) {[otherTitles addObject:argString];}
            } else {
                NSAssert(NO, @"otherActionTitle 参数表必须为 NSString 类型");
            }
        }
        va_end(argList);                        // 收尾，记得关闭关闭 va_list
    }
    
    return [UIAlertController alertControllerWithTitle:title
                                               message:message
                                        preferredStyle:preferredStyle
                                     cancelActionTitle:cancelActionTitle
                                     otherActionTitles:[otherTitles copy]];
}

+ (instancetype)alertControllerWithTitle:(NSString *)title
                                 message:(NSString *)message
                          preferredStyle:(UIAlertControllerStyle)preferredStyle
                             actionItems:(NSArray<UIAlertActionItem *> *)actionItems {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:preferredStyle];
    __weak typeof(alertController) weakSelf = alertController;
    for (UIAlertActionItem *item in actionItems) {
        if ([item isKindOfClass:[UIAlertActionItem class]]) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:item.title
                                                             style:item.style
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               __strong typeof(weakSelf) strongSelf = weakSelf;
                                                               if (strongSelf.alertActionHandler) {
                                                                   strongSelf.alertActionHandler(action);
                                                               }
                                                           }];
            if (action) {[alertController addAction:action];}
        } else {
            NSAssert(NO, @"actionItems 数组元素必须为 UIAlertActionItem 类型");
        }
    }
    
    return alertController;
}

@end
