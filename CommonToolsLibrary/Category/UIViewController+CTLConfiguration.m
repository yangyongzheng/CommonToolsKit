//
//  UIViewController+CTLConfiguration.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/10/12.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import "UIViewController+CTLConfiguration.h"
#import <objc/runtime.h>

static const void * CTLPageNumberAssociationKey         = (void *)&CTLPageNumberAssociationKey;
static const void * CTLPageSizeAssociationKey           = (void *)&CTLPageSizeAssociationKey;
static const void * CTLIsRequestingAssociationKey       = (void *)&CTLIsRequestingAssociationKey;
static const void * CTLIsRequestSuccessAssociationKey   = (void *)&CTLIsRequestSuccessAssociationKey;

@implementation UIViewController (CTLConfiguration)

@dynamic pageNumber, pageSize, isRequesting, isRequestSuccess;

- (NSInteger)pageNumber {
    NSInteger numner = [objc_getAssociatedObject(self, CTLPageNumberAssociationKey) integerValue];
    if (numner < 1) {
        numner = 1;
        [self setPageNumber:numner];
    }
    return numner;
}

- (void)setPageNumber:(NSInteger)pageNumber {
    objc_setAssociatedObject(self,
                             CTLPageNumberAssociationKey,
                             [NSNumber numberWithInteger:pageNumber],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)pageSize {
    NSInteger size = [objc_getAssociatedObject(self, CTLPageSizeAssociationKey) integerValue];
    if (size < 10) {
        size = 10;
        [self setPageSize:size];
    }
    return size;
}

- (void)setPageSize:(NSInteger)pageSize {
    objc_setAssociatedObject(self,
                             CTLPageSizeAssociationKey,
                             [NSNumber numberWithInteger:pageSize],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isRequesting {
    return [objc_getAssociatedObject(self, CTLIsRequestingAssociationKey) boolValue];
}

- (void)setIsRequesting:(BOOL)isRequesting {
    objc_setAssociatedObject(self,
                             CTLIsRequestingAssociationKey,
                             [NSNumber numberWithBool:isRequesting],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isRequestSuccess {
    return [objc_getAssociatedObject(self, CTLIsRequestSuccessAssociationKey) boolValue];
}

- (void)setIsRequestSuccess:(BOOL)isRequestSuccess {
    objc_setAssociatedObject(self,
                             CTLIsRequestSuccessAssociationKey,
                             [NSNumber numberWithBool:isRequestSuccess],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
