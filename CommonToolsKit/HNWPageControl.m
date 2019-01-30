//
//  HNWPageControl.m
//  HNWPageControl
//
//  Created by 杨永正 on 2019/1/29.
//  Copyright © 2019年 yangyongzheng. All rights reserved.
//

#import "HNWPageControl.h"

@interface HNWPageControl ()
@property (nonatomic, strong) NSMutableArray<UIImageView *> *indicatorImageViews;
// Data
@property (nonatomic) BOOL forceUpdate;
@property (nonatomic) UIViewContentMode indicatorContentMode;
@end

@implementation HNWPageControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configurePropertys];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configurePropertys];
    }
    
    return self;
}

- (void)configurePropertys {
    self.userInteractionEnabled = NO;
    _indicatorImageViews = [NSMutableArray array];
    
    _animateDuration = 0.3;
    _hidesForSinglePage = YES;
    _pageIndicatorSpaing = 5.0;
    _pageIndicatorSize = CGSizeMake(10, 10);
    _currentPageIndicatorSize = CGSizeMake(10, 10);
    _pageIndicatorTintColor = UIColor.grayColor;
    _currentPageIndicatorTintColor = UIColor.redColor;
    _contentAlignment = HNWPageControlContentAlignmentCenter;
    _indicatorContentMode = UIViewContentModeScaleToFill;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self layoutIndicatorViews];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview) {
        _forceUpdate = YES;
        [self updateIndicatorViews];
        _forceUpdate = NO;
    }
}

#pragma mark - update indicator
- (void)updateIndicatorViews {
    if (!self.superview && !_forceUpdate) {
        return;
    }
    
    if (_indicatorImageViews.count == _numberOfPages) {
        [self updateIndicatorViewsBehavior];
        return;
    }
    
    if (_indicatorImageViews.count < _numberOfPages) {
        for (NSInteger idx = _indicatorImageViews.count; idx < _numberOfPages; idx++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = _indicatorContentMode;
            [self addSubview:imageView];
            [_indicatorImageViews addObject:imageView];
        }
    } else if (_indicatorImageViews.count > _numberOfPages) {
        for (NSInteger idx = _indicatorImageViews.count - 1; idx >= _numberOfPages; idx--) {
            UIImageView *imageView = _indicatorImageViews[idx];
            [imageView removeFromSuperview];
            [_indicatorImageViews removeObjectAtIndex:idx];
        }
    }
    
    [self updateIndicatorViewsBehavior];
}

- (void)updateIndicatorViewsBehavior {
    if (_indicatorImageViews.count == 0 || (!self.superview && !_forceUpdate)) {
        return;
    }
    
    if (_hidesForSinglePage && _indicatorImageViews.count <= 1) {
        self.hidden = YES;
        return;
    }
    // 重置
    self.hidden = NO;
    
    NSInteger index = 0;
    for (UIImageView *indicatorView in _indicatorImageViews) {
        if (_pageIndicatorImage) {
            indicatorView.contentMode = _indicatorContentMode;
            indicatorView.image = _currentPage == index ? _currentPageIndicatorImage : _pageIndicatorImage;
        } else {
            indicatorView.image = nil;
            indicatorView.backgroundColor = _currentPage == index ? _currentPageIndicatorTintColor : _pageIndicatorTintColor;
        }
        indicatorView.layer.cornerRadius = self.pageIndicatorCornerRadius;
        indicatorView.layer.masksToBounds = self.pageIndicatorCornerRadius > 0 ? YES : NO;
        
        index++;
    }
}

#pragma mark - layout
- (void)layoutIndicatorViews {
    if (_indicatorImageViews.count == 0) {
        return;
    }
    CGFloat originX = 0;
    CGFloat centerY = 0;
    CGFloat pageIndicatorSpaing = _pageIndicatorSpaing;
    
    switch (self.contentAlignment) {
        case HNWPageControlContentAlignmentCenter:
            // ignore contentInset
            originX = (CGRectGetWidth(self.frame) - (_indicatorImageViews.count-1)*(_pageIndicatorSize.width+_pageIndicatorSpaing) - _currentPageIndicatorSize.width) / 2.0;
            centerY = CGRectGetHeight(self.frame) / 2.0;
            break;
        case HNWPageControlContentAlignmentTop:
            originX = (CGRectGetWidth(self.frame) - (_indicatorImageViews.count-1)*(_pageIndicatorSize.width+_pageIndicatorSpaing) - _currentPageIndicatorSize.width) / 2.0;
            centerY = _contentInset.top + _currentPageIndicatorSize.height / 2.0;
            break;
        case HNWPageControlContentAlignmentLeft:
            originX = _contentInset.left;
            centerY = CGRectGetHeight(self.frame) / 2.0;
            break;
        case HNWPageControlContentAlignmentBottom:
            originX = (CGRectGetWidth(self.frame) - (_indicatorImageViews.count-1)*(_pageIndicatorSize.width+_pageIndicatorSpaing) - _currentPageIndicatorSize.width) / 2.0;
            centerY = CGRectGetHeight(self.frame) - _currentPageIndicatorSize.height / 2.0 - _contentInset.bottom;
            break;
        case HNWPageControlContentAlignmentRight:
            originX = CGRectGetWidth(self.frame) - ((_indicatorImageViews.count-1)*(_pageIndicatorSize.width+_pageIndicatorSpaing) + _currentPageIndicatorSize.width) - _contentInset.right;
            centerY = CGRectGetHeight(self.frame) / 2.0;
            break;
        case HNWPageControlContentAlignmentTopLeft:
            originX = _contentInset.left;
            centerY = _contentInset.top + _currentPageIndicatorSize.height / 2.0;
            break;
        case HNWPageControlContentAlignmentTopRight:
            originX = CGRectGetWidth(self.frame) - ((_indicatorImageViews.count-1)*(_pageIndicatorSize.width+_pageIndicatorSpaing) + _currentPageIndicatorSize.width) - _contentInset.right;
            centerY = _contentInset.top + _currentPageIndicatorSize.height / 2.0;
            break;
        case HNWPageControlContentAlignmentBottomLeft:
            originX = _contentInset.left;
            centerY = CGRectGetHeight(self.frame) - _currentPageIndicatorSize.height / 2.0 - _contentInset.bottom;
            break;
        case HNWPageControlContentAlignmentBottomRight:
            originX = CGRectGetWidth(self.frame) - ((_indicatorImageViews.count-1)*(_pageIndicatorSize.width+_pageIndicatorSpaing) + _currentPageIndicatorSize.width) - _contentInset.right;
            centerY = CGRectGetHeight(self.frame) - _currentPageIndicatorSize.height / 2.0 - _contentInset.bottom;
            break;
        default:
            break;
    }
    
    NSInteger index = 0;
    for (UIImageView *indicatorView in _indicatorImageViews) {
        CGSize size = index == _currentPage ? _currentPageIndicatorSize : _pageIndicatorSize;
        indicatorView.frame = CGRectMake(originX, centerY-size.height/2, size.width, size.height);
        originX += size.width + pageIndicatorSpaing;
        ++index;
    }
}

#pragma mark - getter or setter
- (void)setNumberOfPages:(NSInteger)numberOfPages {
    if (numberOfPages < 0) {numberOfPages = 0;}
    if (numberOfPages == _numberOfPages) {
        return;
    }
    
    _numberOfPages = numberOfPages;
    
    if (_currentPage >= numberOfPages) {
        _currentPage = 0;
    }
    
    [self updateIndicatorViews];
    
    if (_indicatorImageViews.count > 0) {
        [self setNeedsLayout];
    }
}

- (void)setCurrentPage:(NSInteger)currentPage {
    if (_currentPage == currentPage || _indicatorImageViews.count <= currentPage) {
        return;
    }
    
    _currentPage = currentPage;
    
    [self updateIndicatorViewsBehavior];
    if (!CGSizeEqualToSize(_currentPageIndicatorSize, _pageIndicatorSize)) {
        [self setNeedsLayout];
    }
}

- (void)setCurrentPage:(NSInteger)currentPage animate:(BOOL)animate {
    if (animate) {
        [UIView animateWithDuration:_animateDuration animations:^{
            [self setCurrentPage:currentPage];
        }];
    } else {
        [self setCurrentPage:currentPage];
    }
}

- (void)setPageIndicatorSpaing:(CGFloat)pageIndicatorSpaing {
    _pageIndicatorSpaing = pageIndicatorSpaing;
    if (_indicatorImageViews.count > 0) {
        [self setNeedsLayout];
    }
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    if (!UIEdgeInsetsEqualToEdgeInsets(_contentInset, contentInset)) {
        _contentInset = contentInset;
        
        if (_indicatorImageViews.count > 0) {
            [self setNeedsLayout];
        }
    }
}

- (void)setContentAlignment:(HNWPageControlContentAlignment)contentAlignment {
    if (_contentAlignment != contentAlignment) {
        _contentAlignment = contentAlignment;
        
        if (_indicatorImageViews.count > 0) {
            [self setNeedsLayout];
        }
    }
}

- (void)setPageIndicatorSize:(CGSize)pageIndicatorSize {
    if (CGSizeEqualToSize(_pageIndicatorSize, pageIndicatorSize)) {
        return;
    }
    _pageIndicatorSize = pageIndicatorSize;
    if (CGSizeEqualToSize(_currentPageIndicatorSize, CGSizeZero) ||
        (_currentPageIndicatorSize.width < pageIndicatorSize.width && _currentPageIndicatorSize.height < pageIndicatorSize.height)) {
        _currentPageIndicatorSize = pageIndicatorSize;
    }
    if (_indicatorImageViews.count > 0) {
        [self setNeedsLayout];
    }
}

- (void)setCurrentPageIndicatorSize:(CGSize)currentPageIndicatorSize {
    if (CGSizeEqualToSize(_currentPageIndicatorSize, currentPageIndicatorSize)) {
        return;
    }
    _currentPageIndicatorSize = currentPageIndicatorSize;
    if (_indicatorImageViews.count > 0) {
        [self setNeedsLayout];
    }
}

- (void)setPageIndicatorCornerRadius:(CGFloat)pageIndicatorCornerRadius {
    if (pageIndicatorCornerRadius < 0) {
        pageIndicatorCornerRadius = 0;
    }
    if (_pageIndicatorCornerRadius != pageIndicatorCornerRadius) {
        _pageIndicatorCornerRadius = pageIndicatorCornerRadius;
        [self updateIndicatorViewsBehavior];
    }
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    _pageIndicatorTintColor = pageIndicatorTintColor;
    [self updateIndicatorViewsBehavior];
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    [self updateIndicatorViewsBehavior];
}

- (void)setPageIndicatorImage:(UIImage *)pageIndicatorImage {
    _pageIndicatorImage = pageIndicatorImage;
    [self updateIndicatorViewsBehavior];
}

- (void)setCurrentPageIndicatorImage:(UIImage *)currentPageIndicatorImage {
    _currentPageIndicatorImage = currentPageIndicatorImage;
    [self updateIndicatorViewsBehavior];
}

@end
