//
//  ESSVBadgeTextCollectionViewCell.m
//  YZKit
//
//  Created by 杨永正 on 2018/8/29.
//  Copyright © 2018 yangyongzheng. All rights reserved.
//

#import "ESSVBadgeTextCollectionViewCell.h"

@implementation ESSVBadgeTextCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.badgeButton.adjustsImageWhenHighlighted = NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _badgeButton.layer.cornerRadius = CGRectGetHeight(_badgeButton.frame) / 2.0;
    _badgeButton.layer.masksToBounds = YES;    
}

@end
