//
//  UIView+CTLLayout.h
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/10/13.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CTLLayout)

@property (nonatomic, assign) IBInspectable CGFloat ctl_cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat ctl_borderWidth;
@property (nonatomic, strong) IBInspectable UIColor *ctl_borderColor;

/** frame */
@property (nonatomic) CGFloat ctl_minX;
@property (nonatomic) CGFloat ctl_midX;
@property (nonatomic) CGFloat ctl_maxX;
@property (nonatomic) CGFloat ctl_minY;
@property (nonatomic) CGFloat ctl_midY;
@property (nonatomic) CGFloat ctl_maxY;
@property (nonatomic) CGFloat ctl_width;
@property (nonatomic) CGFloat ctl_height;
@property (nonatomic) CGPoint ctl_origin;
@property (nonatomic) CGSize  ctl_size;

/** add corners
 注意UIView的frame必须为最终布局后frame.
 */
- (void)ctl_setCornerRedius:(CGFloat)cornerRedius withCorners:(UIRectCorner)corners;

@end

NS_ASSUME_NONNULL_END
