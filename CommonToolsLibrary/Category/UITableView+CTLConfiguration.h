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

- (void)registerNibWithNibName:(NSString *)nibName forCellReuseIdentifier:(NSString *)identifier;
- (void)registerNibWithNibName:(NSString *)nibName forHeaderFooterViewReuseIdentifier:(NSString *)identifier;

- (void)resetDefaultConfiguration;

@end

NS_ASSUME_NONNULL_END
