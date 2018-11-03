//
//  UIViewController+CTLConfiguration.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/10/12.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import "UIViewController+CTLConfiguration.h"
#import <objc/runtime.h>

static const void * CTLPageNumberAssociationKey         =   (void *)&CTLPageNumberAssociationKey;
static const void * CTLPageSizeAssociationKey           =   (void *)&CTLPageSizeAssociationKey;
static const void * CTLIsRequestingAssociationKey       =   (void *)&CTLIsRequestingAssociationKey;
static const void * CTLIsRequestSuccessAssociationKey   =   (void *)&CTLIsRequestSuccessAssociationKey;

@implementation UIViewController (CTLConfiguration)

@dynamic ctl_pageNumber, ctl_pageSize, ctl_isRequesting, ctl_isRequestSuccess;

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

- (BOOL)ctl_isRequesting {
    return [objc_getAssociatedObject(self, CTLIsRequestingAssociationKey) boolValue];
}

- (void)setCtl_isRequesting:(BOOL)ctl_isRequesting {
    objc_setAssociatedObject(self,
                             CTLIsRequestingAssociationKey,
                             [NSNumber numberWithBool:ctl_isRequesting],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)ctl_isRequestSuccess {
    return [objc_getAssociatedObject(self, CTLIsRequestSuccessAssociationKey) boolValue];
}

- (void)setCtl_isRequestSuccess:(BOOL)ctl_isRequestSuccess {
    objc_setAssociatedObject(self,
                             CTLIsRequestSuccessAssociationKey,
                             [NSNumber numberWithBool:ctl_isRequestSuccess],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
