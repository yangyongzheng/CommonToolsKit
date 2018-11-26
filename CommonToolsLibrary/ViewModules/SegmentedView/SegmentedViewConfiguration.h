//
//  SegmentedViewConfiguration.h
//  YZKit
//
//  Created by 杨永正 on 2018/8/27.
//  Copyright © 2018 yangyongzheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentedViewConfiguration : NSObject
@property (nonatomic) CGFloat itemSpacing;          // item间间距，默认值 0
@property (nonatomic) CGFloat contentLeftMargin;    // 左边距，默认值 0
@property (nonatomic) CGFloat contentRightMargin;   // 右边距，默认值 0
// separator（上下分割线）
@property (nonatomic) CGFloat separatorHeight;          // 默认值 0.5
@property (nonatomic, strong) UIColor *separatorColor;  // 默认值 #DCDCDC
@property (nonatomic) CGFloat separatorLeftMargin;      // 默认值 0
@property (nonatomic) CGFloat separatorRightMargin;     // 默认值 0
// indicator（选中指示器）
@property (nonatomic) CGFloat indicatorHeight;          // 默认值 2.0
@property (nonatomic, strong) UIColor *indicatorColor;  // 默认值 #66BB47
@property (nonatomic) CGFloat indicatorOffset;          // 默认值 0，指示器相对于标题的偏移量
// item
@property (nonatomic, strong) UIColor *selectedTitleColor;  // 默认值 #66BB47
@property (nonatomic, strong) UIColor *unselectedTitleColor;// 默认值 #333333
@property (nonatomic, strong) UIFont *selectedTitleFont;    // 默认值 [UIFont boldSystemFontOfSize:15]
@property (nonatomic, strong) UIFont *unselectedTitleFont;  // 默认值 [UIFont systemFontOfSize:15]

// 获取实例对象，非单例
@property (class, readonly, strong) SegmentedViewConfiguration *defaultConfiguration;
@end
