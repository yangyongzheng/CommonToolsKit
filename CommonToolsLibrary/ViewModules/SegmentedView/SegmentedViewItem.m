//
//  SegmentedViewItem.m
//  YZKit
//
//  Created by 杨永正 on 2018/8/27.
//  Copyright © 2018 yangyongzheng. All rights reserved.
//

#import "SegmentedViewItem.h"


@implementation SegmentedViewBadgeDot

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dotDiameter = 10;
    }
    return self;
}

+ (instancetype)badgeDot {
    return [[SegmentedViewBadgeDot alloc] init];
}

@end

@implementation SegmentedViewBadgeText

+ (instancetype)badgeWithValue:(NSString *)badgeValue {
    SegmentedViewBadgeText *badge = [[SegmentedViewBadgeText alloc] init];
    badge->_badgeValue = badgeValue;
    return badge;
}

@end

@implementation SegmentedViewBadgeImage

+ (instancetype)badgeWithImageName:(NSString *)imageName imageSize:(CGSize)imageSize {
    SegmentedViewBadgeImage *badge = [[SegmentedViewBadgeImage alloc] init];
    badge->_imageName = imageName;
    badge->_imageSize = imageSize;
    return badge;
}

@end


@implementation SegmentedViewItem

+ (instancetype)itemWithTitle:(NSString *)title {
    SegmentedViewItem *item = [[SegmentedViewItem alloc] init];
    item.title = title;
    item.badgeOffset = UIOffsetMake(-2.0, 2.0);
    return item;
}

@end
