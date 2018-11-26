//
//  SegmentedViewConfiguration.m
//  YZKit
//
//  Created by 杨永正 on 2018/8/27.
//  Copyright © 2018 yangyongzheng. All rights reserved.
//

#import "SegmentedViewConfiguration.h"

@implementation SegmentedViewConfiguration

+ (SegmentedViewConfiguration *)defaultConfiguration {
    SegmentedViewConfiguration *configuration = [[SegmentedViewConfiguration alloc] init];
    configuration.itemSpacing = 0;
    configuration.contentLeftMargin = 0;
    configuration.contentRightMargin = 0;
    
    configuration.separatorHeight = 0.5;
    configuration.separatorColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];
    configuration.separatorLeftMargin = 0;
    configuration.separatorRightMargin = 0;
    
    configuration.indicatorHeight = 2.0;
    configuration.indicatorColor = [UIColor colorWithRed:102.0/255.0 green:187.0/255.0 blue:71.0/255.0 alpha:1.0];
    configuration.indicatorOffset = 0;
    
    configuration.selectedTitleColor = [UIColor colorWithRed:102.0/255.0 green:187.0/255.0 blue:71.0/255.0 alpha:1.0];
    configuration.unselectedTitleColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    configuration.selectedTitleFont = [UIFont boldSystemFontOfSize:15];
    configuration.unselectedTitleFont = [UIFont systemFontOfSize:15];
    
    return configuration;
}

@end
