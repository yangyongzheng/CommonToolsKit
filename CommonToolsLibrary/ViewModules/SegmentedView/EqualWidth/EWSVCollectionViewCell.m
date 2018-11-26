//
//  EWSVCollectionViewCell.m
//  YZKit
//
//  Created by 杨永正 on 2018/8/27.
//  Copyright © 2018 yangyongzheng. All rights reserved.
//

#import "EWSVCollectionViewCell.h"

@implementation EWSVCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _badgeButton.adjustsImageWhenHighlighted = NO;
}

- (void)resetBadge {
    _badgeButton.hidden = YES;
    _badgeImageView.hidden = YES;
    _badgeImageView.image = nil;
    _badgeImageView.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _badgeButton.layer.cornerRadius = CGRectGetHeight(_badgeButton.frame) / 2.0;
    _badgeButton.layer.masksToBounds = YES;
    if (_badgeImageView.image) {// 图片角标
        _badgeImageView.layer.cornerRadius = 0;
        _badgeImageView.layer.masksToBounds = NO;
    } else {                    // 红点角标
        _badgeImageView.layer.cornerRadius = CGRectGetHeight(_badgeImageView.frame) / 2.0;
        _badgeImageView.layer.masksToBounds = YES;
    }
}

@end
