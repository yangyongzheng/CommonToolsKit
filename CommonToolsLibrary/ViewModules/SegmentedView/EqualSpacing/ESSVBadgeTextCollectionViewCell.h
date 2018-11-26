//
//  ESSVBadgeTextCollectionViewCell.h
//  YZKit
//
//  Created by 杨永正 on 2018/8/29.
//  Copyright © 2018 yangyongzheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSVBadgeTextCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *badgeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *badgeButtonLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *badgeButtonBottomConstraint;

@end
