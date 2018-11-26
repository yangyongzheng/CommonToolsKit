//
//  SegmentedViewItem.h
//  YZKit
//
//  Created by 杨永正 on 2018/8/27.
//  Copyright © 2018 yangyongzheng. All rights reserved.
//

#import <UIKit/UIKit.h>

////////////////////////// 角标类型model //////////////////////////
@interface SegmentedViewBadgeDot : NSObject
@property (nonatomic) CGFloat dotDiameter;  // 小红点直径, 默认 10

+ (instancetype)badgeDot;
@end

@interface SegmentedViewBadgeText : NSObject
@property (nonatomic, readonly, copy) NSString *badgeValue;

+ (instancetype)badgeWithValue:(NSString *)badgeValue;
@end

@interface SegmentedViewBadgeImage : NSObject
@property (nonatomic, readonly, copy) NSString *imageName;
@property (nonatomic, readonly) CGSize imageSize;

+ (instancetype)badgeWithImageName:(NSString *)imageName imageSize:(CGSize)imageSize;
@end
//////////////////////////////////////////////////////////////////


@interface SegmentedViewItem : NSObject

// required
@property (nonatomic, copy) NSString *title;

// optional
// 优先级 image > text > dot
@property (nonatomic, strong) SegmentedViewBadgeDot *badgeDot;
@property (nonatomic, strong) SegmentedViewBadgeText *badgeText;
@property (nonatomic, strong) SegmentedViewBadgeImage *badgeImage;

/** 设置badge相对于title的偏移量, 默认为{-2.0, 2.0}
 badge.left = title.right + badgeOffset.horizontal
 badge.bottom = title.top + badgeOffset.vertical
 */
@property (nonatomic) UIOffset badgeOffset;

+ (instancetype)itemWithTitle:(NSString *)title;

@end
