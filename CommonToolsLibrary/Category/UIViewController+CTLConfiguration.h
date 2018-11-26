//
//  UIViewController+CTLConfiguration.h
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/10/12.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 接口请求状态枚举 */
typedef NS_ENUM(NSInteger, CTLRequestState) {
    CTLRequestStateIdle         = 0,    // 闲置状态
    CTLRequestStateRequesting   = 1,    // 正在请求中
    CTLRequestStateSuccess      = 2,    // 请求成功
    CTLRequestStateFailure      = 3,    // 请求失败
};

@interface UIViewController (CTLConfiguration)

@property (nonatomic) NSInteger ctl_pageNumber;
@property (nonatomic) NSInteger ctl_pageSize;
@property (nonatomic) CTLRequestState ctl_requestState;

@end

NS_ASSUME_NONNULL_END
