//
//  UIViewController+CTLConfiguration.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/10/12.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import "UIViewController+CTLConfiguration.h"
#import <objc/runtime.h>

static const void * CTLPageNumberAssociationKey     =   (void *)&CTLPageNumberAssociationKey;
static const void * CTLPageSizeAssociationKey       =   (void *)&CTLPageSizeAssociationKey;
static const void * CTLRequestStateAssociationKey   =   (void *)&CTLRequestStateAssociationKey;

@implementation UIViewController (CTLConfiguration)

@dynamic ctl_pageNumber, ctl_pageSize, ctl_requestState;

- (NSInteger)ctl_pageNumber {
    NSInteger numner = [objc_getAssociatedObject(self, CTLPageNumberAssociationKey) integerValue];
    if (numner < 1) {
        numner = 1;
        [self setCtl_pageNumber:numner];
    }
    return numner;
}

- (void)setCtl_pageNumber:(NSInteger)ctl_pageNumber {
    objc_setAssociatedObject(self,
                             CTLPageNumberAssociationKey,
                             [NSNumber numberWithInteger:ctl_pageNumber],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)ctl_pageSize {
    NSInteger size = [objc_getAssociatedObject(self, CTLPageSizeAssociationKey) integerValue];
    if (size < 10) {
        size = 10;
        [self setCtl_pageSize:size];
    }
    return size;
}

- (void)setCtl_pageSize:(NSInteger)ctl_pageSize {
    objc_setAssociatedObject(self,
                             CTLPageSizeAssociationKey,
                             [NSNumber numberWithInteger:ctl_pageSize],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CTLRequestState)ctl_requestState {
    return (CTLRequestState)[objc_getAssociatedObject(self, CTLRequestStateAssociationKey) integerValue];
}

- (void)setCtl_requestState:(CTLRequestState)ctl_requestState {
    objc_setAssociatedObject(self,
                             CTLRequestStateAssociationKey,
                             [NSNumber numberWithInteger:ctl_requestState],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
