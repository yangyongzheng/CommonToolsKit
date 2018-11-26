//
//  ESSVBadgeImageCollectionViewCell.h
//  YZKit
//
//  Created by 杨永正 on 2018/8/29.
//  Copyright © 2018 yangyongzheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSVBadgeImageCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *badgeImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *badgeImageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *badgeImageViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *badgeImageViewLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *badgeImageViewBottomConstraint;

@end
