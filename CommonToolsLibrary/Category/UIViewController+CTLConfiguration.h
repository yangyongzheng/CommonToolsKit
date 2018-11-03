//
//  UIViewController+CTLConfiguration.h
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/10/12.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (CTLConfiguration)

@property (nonatomic) NSInteger ctl_pageNumber;
@property (nonatomic) NSInteger ctl_pageSize;
@property (nonatomic) BOOL ctl_isRequesting;
@property (nonatomic) BOOL ctl_isRequestSuccess;

@end

NS_ASSUME_NONNULL_END
