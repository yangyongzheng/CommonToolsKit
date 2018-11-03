//
//  UITableView+CTLConfiguration.h
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/10/12.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (CTLConfiguration)

- (void)ctl_registerNibWithNibName:(NSString *)nibName forCellReuseIdentifier:(NSString *)identifier;
- (void)ctl_registerNibWithNibName:(NSString *)nibName forHeaderFooterViewReuseIdentifier:(NSString *)identifier;

- (void)ctl_resetDefaultConfiguration;

@end

NS_ASSUME_NONNULL_END
