//
//  HNWPageControl.h
//  HNWPageControl
//
//  Created by 杨永正 on 2019/1/29.
//  Copyright © 2019年 yangyongzheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HNWPageControlContentAlignment) {
    HNWPageControlContentAlignmentCenter = 0, // default
    HNWPageControlContentAlignmentTop,
    HNWPageControlContentAlignmentLeft,
    HNWPageControlContentAlignmentBottom,
    HNWPageControlContentAlignmentRight,
    HNWPageControlContentAlignmentTopLeft,
    HNWPageControlContentAlignmentTopRight,
    HNWPageControlContentAlignmentBottomLeft,
    HNWPageControlContentAlignmentBottomRight,
};

@interface HNWPageControl : UIView
@property (nonatomic) NSInteger numberOfPages;      // 默认值 0
@property (nonatomic) NSInteger currentPage;        // 默认值 0. 范围 0...numberOfPages-1
@property (nonatomic) BOOL hidesForSinglePage;      // 单个是否隐藏，默认值 YES
@property (nonatomic) CGFloat pageIndicatorSpaing;  // 间距 5
@property (nonatomic) CGFloat pageIndicatorCornerRadius;// 默认值 0
@property (nonatomic) UIEdgeInsets contentInset;    // 水平居中对齐时，忽略.left与.right，垂直居中对齐时，忽略.top与.bottom
@property (nonatomic) HNWPageControlContentAlignment contentAlignment;          // 默认 HNWPageControlContentAlignmentCenter

@property (nonatomic) CGSize pageIndicatorSize;         // 默认值{10, 10}
@property (nonatomic) CGSize currentPageIndicatorSize;  // 默认值{10, 10}

@property (nullable, nonatomic, strong) UIColor *pageIndicatorTintColor;        // 默认值 UIColor.grayColor
@property (nullable, nonatomic, strong) UIColor *currentPageIndicatorTintColor; // 默认值 UIColor.redColor

@property (nullable, nonatomic, strong) UIImage *pageIndicatorImage;            // 默认值 nil
@property (nullable, nonatomic, strong) UIImage *currentPageIndicatorImage;     // 默认值 nil

@property (nonatomic) CGFloat animateDuration;                                  // 默认 0.3s

- (void)setCurrentPage:(NSInteger)currentPage animate:(BOOL)animate;
@end

NS_ASSUME_NONNULL_END
