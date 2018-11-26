//
//  ESSVBadgeImageCollectionViewCell.m
//  YZKit
//
//  Created by 杨永正 on 2018/8/29.
//  Copyright © 2018 yangyongzheng. All rights reserved.
//

#import "ESSVBadgeImageCollectionViewCell.h"

@implementation ESSVBadgeImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_badgeImageView.image) {// 图片角标
        _badgeImageView.layer.cornerRadius = 0;
        _badgeImageView.layer.masksToBounds = NO;
    } else {                    // 红点角标
        _badgeImageView.layer.cornerRadius = CGRectGetHeight(_badgeImageView.frame) / 2.0;
        _badgeImageView.layer.masksToBounds = YES;
    }
}

@end
