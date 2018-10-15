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

@property (nonatomic) NSInteger pageNumber;
@property (nonatomic) NSInteger pageSize;
@property (nonatomic) BOOL isRequesting;
@property (nonatomic) BOOL isRequestSuccess;

@end

NS_ASSUME_NONNULL_END
