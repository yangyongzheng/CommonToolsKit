//
//  UIView+CTLLayout.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/10/13.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import "UIView+CTLLayout.h"

@implementation UIView (CTLLayout)

@dynamic cornerRadius, borderWidth, borderColor;

- (void)setCornerRadius:(CGFloat)cornerRadius {
    if (cornerRadius < 0) {cornerRadius = 0;}
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius>0 ? YES : NO;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    if (borderWidth < 0) {borderWidth = 0;}
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

#pragma mark - frame
- (CGFloat)ctl_minX {
    return self.frame.origin.x;
}

- (void)setCtl_minX:(CGFloat)minX {
    CGRect tempFrame = self.frame;
    tempFrame.origin.x = minX;
    self.frame = tempFrame;
}

- (CGFloat)ctl_midX {
    return self.center.x;
}

- (void)setCtl_midX:(CGFloat)midX {
    self.center = CGPointMake(midX, self.center.y);
}

- (CGFloat)ctl_maxX {
    return CGRectGetMaxX(self.frame);
}

- (void)setCtl_maxX:(CGFloat)maxX {
    CGRect tempFrame = self.frame;
    tempFrame.origin.x = maxX - tempFrame.size.width;
    self.frame = tempFrame;
}

- (CGFloat)ctl_minY {
    return self.frame.origin.y;
}

- (void)setCtl_minY:(CGFloat)minY {
    CGRect tempFrame = self.frame;
    tempFrame.origin.y = minY;
    self.frame = tempFrame;
}

- (CGFloat)ctl_midY {
    return self.center.y;
}

- (void)setCtl_midY:(CGFloat)midY {
    self.center = CGPointMake(self.center.x, midY);
}

- (CGFloat)ctl_maxY {
    return CGRectGetMaxY(self.frame);
}

- (void)setCtl_maxY:(CGFloat)maxY {
    CGRect tempFrame = self.frame;
    tempFrame.origin.y = maxY - tempFrame.size.height;
    self.frame = tempFrame;
}

- (CGFloat)ctl_width {
    return self.frame.size.width;
}

- (void)setCtl_width:(CGFloat)width {
    CGRect tempFrame = self.frame;
    tempFrame.size.width = width;
    self.frame = tempFrame;
}

- (CGFloat)ctl_height {
    return self.frame.size.height;
}

- (void)setCtl_height:(CGFloat)height {
    CGRect tempFrame = self.frame;
    tempFrame.size.height = height;
    self.frame = tempFrame;
}

- (CGPoint)ctl_origin {
    return self.frame.origin;
}

- (void)setCtl_origin:(CGPoint)origin {
    CGRect tempFrame = self.frame;
    tempFrame.origin = origin;
    self.frame = tempFrame;
}

- (CGSize)ctl_size {
    return self.frame.size;
}

- (void)setCtl_size:(CGSize)size {
    CGRect tempFrame = self.frame;
    tempFrame.size = size;
    self.frame = tempFrame;
}

#pragma mark - add corner
- (void)setCornerRedius:(CGFloat)cornerRedius withCorners:(UIRectCorner)corners {
    if (cornerRedius > 0) {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                       byRoundingCorners:corners
                                                             cornerRadii:CGSizeMake(cornerRedius, cornerRedius)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
    } else {
        self.layer.mask = nil;
    }
}

@end
