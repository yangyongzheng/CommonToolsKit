//
//  UITableView+CTLConfiguration.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/10/12.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import "UITableView+CTLConfiguration.h"

@implementation UITableView (CTLConfiguration)

- (void)ctl_registerNibWithNibName:(NSString *)nibName forCellReuseIdentifier:(NSString *)identifier {
    [self registerNib:[UINib nibWithNibName:nibName bundle:NSBundle.mainBundle] forCellReuseIdentifier:identifier];
}

- (void)ctl_registerNibWithNibName:(NSString *)nibName forHeaderFooterViewReuseIdentifier:(NSString *)identifier {
    [self registerNib:[UINib nibWithNibName:nibName bundle:NSBundle.mainBundle] forHeaderFooterViewReuseIdentifier:identifier];
}

- (void)ctl_resetDefaultConfiguration {
    self.rowHeight = 0;
    self.estimatedRowHeight = 0;
    self.sectionHeaderHeight = 0;
    self.sectionFooterHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.backgroundColor = [UIColor whiteColor];
}

@end
