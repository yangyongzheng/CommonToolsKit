//
//  EqualWidthSegmentedView.m
//  YZKit
//
//  Created by 杨永正 on 2018/8/27.
//  Copyright © 2018 yangyongzheng. All rights reserved.
//

#import "EqualWidthSegmentedView.h"
#import "EWSVCollectionViewCell.h"

@interface EqualWidthSegmentedView ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic) NSUInteger selectedIndex;
@end

@implementation EqualWidthSegmentedView

@synthesize headerLineView = _headerLineView;
@synthesize footerLineView = _footerLineView;
@synthesize indicatorView = _indicatorView;

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.headerLineView.frame = CGRectMake(self.configuration.separatorLeftMargin,
                                           0,
                                           self.bounds.size.width-self.configuration.separatorLeftMargin-self.configuration.separatorRightMargin,
                                           self.configuration.separatorHeight);
    self.footerLineView.frame = CGRectMake(self.configuration.separatorLeftMargin,
                                           self.bounds.size.height-self.configuration.separatorHeight,
                                           self.bounds.size.width-self.configuration.separatorLeftMargin-self.configuration.separatorRightMargin,
                                           self.configuration.separatorHeight);
    if (!CGRectEqualToRect(self.collectionView.frame, self.bounds)) {
        self.collectionView.frame = self.bounds;
        [self reloadDataWithoutAnimation];
    }
}

#pragma mark - Public
- (instancetype)initWithFrame:(CGRect)frame
                        items:(NSArray<SegmentedViewItem *> *)items
                configuration:(SegmentedViewConfiguration *)configuration
                     delegate:(id<EqualWidthSegmentedViewDelegate>)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        self->_itemsArray = [items copy];
        self->_configuration = configuration;
        self.delegate = delegate;
        self.selectedIndex = 0;
        [self initializeConfiguration];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                        items:(NSArray<SegmentedViewItem *> *)items
            selectItemAtIndex:(NSUInteger)index
                configuration:(SegmentedViewConfiguration *)configuration
                     delegate:(id<EqualWidthSegmentedViewDelegate>)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        self->_itemsArray = [items copy];
        self->_configuration = configuration;
        self.delegate = delegate;
        self.selectedIndex = index < items.count ? index : 0;
        [self initializeConfiguration];
    }
    
    return self;
}

- (void)setSelectItemAtIndex:(NSUInteger)index animated:(BOOL)animated {
    [self setSelectItemAtIndex:index animated:animated invokeDelegateMethod:YES];
}

- (void)setSelectItemAtIndex:(NSUInteger)index
                    animated:(BOOL)animated
        invokeDelegateMethod:(BOOL)invokeDelegateMethod {
    if (index != self.selectedIndex && index < self.itemsArray.count) {
        self.selectedIndex = index;
        __weak typeof(self) weakSelf = self;
        [UIView performWithoutAnimation:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.collectionView reloadData];
        }];
        [self updateIndicatorViewAnimated:animated];
        if (invokeDelegateMethod &&
            [self.delegate respondsToSelector:@selector(equalWidthSegmentedView:didSelectItem:atIndex:)]) {
            [self.delegate equalWidthSegmentedView:self
                                     didSelectItem:self.itemsArray[self.selectedIndex]
                                           atIndex:self.selectedIndex];
        }
    }
}

- (void)updateSegmentedViewItems:(NSArray<SegmentedViewItem *> *)items {
    self->_itemsArray = [items copy];
    [self reloadDataWithoutAnimation];
}

- (void)updateSegmentedViewItem:(SegmentedViewItem *)item atIndex:(NSInteger)index {
    if ([item isKindOfClass:[SegmentedViewItem class]] && index < self.itemsArray.count) {
        NSMutableArray *tempItems = [NSMutableArray arrayWithArray:self.itemsArray];
        [tempItems replaceObjectAtIndex:index withObject:item];
        self->_itemsArray = [tempItems copy];
        [self reloadDataWithoutAnimation];
    }
}

#pragma mark - Private
- (void)initializeConfiguration {
    [self addSubview:self.headerLineView];
    [self addSubview:self.footerLineView];
    self.headerLineView.backgroundColor = self.configuration.separatorColor;
    self.footerLineView.backgroundColor = self.configuration.separatorColor;
    self.headerLineView.hidden = YES;
    
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.minimumLineSpacing = self.configuration.itemSpacing;
    flowLayout.minimumInteritemSpacing = self.configuration.itemSpacing;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds
                                             collectionViewLayout:flowLayout];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.collectionView.contentInset = UIEdgeInsetsMake(0, self.configuration.contentLeftMargin, 0, self.configuration.contentRightMargin);
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([EWSVCollectionViewCell class])
                                                    bundle:[NSBundle bundleForClass:[EqualWidthSegmentedView class]]]
          forCellWithReuseIdentifier:@"segmented view cell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self addSubview:self.collectionView];
    
    [self.collectionView addSubview:self.indicatorView];
    self.indicatorView.backgroundColor = self.configuration.indicatorColor;
    [self layoutIfNeeded];
    [self updateIndicatorViewAnimated:NO];
}

- (void)reloadDataWithoutAnimation {
    // 更新数据和标示线
    __weak typeof(self) weakSelf = self;
    [UIView performWithoutAnimation:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.collectionView reloadData];
    }];
    [self updateIndicatorViewAnimated:NO];
}

- (void)updateIndicatorViewAnimated:(BOOL)animated {
    if (self.itemsArray.count > 0 && self.selectedIndex < self.itemsArray.count) {
        self.indicatorView.hidden = NO;
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForItem:self.selectedIndex inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:selectedIndexPath];
        if (CGRectGetMinX(attributes.frame)-self.collectionView.contentOffset.x < self.configuration.contentLeftMargin ||
            CGRectGetMaxX(attributes.frame)-self.collectionView.contentOffset.x > self.bounds.size.width-self.configuration.contentRightMargin) {
            [_collectionView scrollToItemAtIndexPath:selectedIndexPath
                                    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                            animated:animated];
        }
        SegmentedViewItem *item = self.itemsArray[self.selectedIndex];
        __weak typeof(self) weakSelf = self;
        [self calculateWidthWithItem:item atIndex:self.selectedIndex result:^(CGFloat titleWidth, CGFloat contentWidth) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            CGFloat y = strongSelf.bounds.size.height - strongSelf.configuration.indicatorHeight;
            CGFloat width = titleWidth - strongSelf.configuration.indicatorOffset * 2.0;
            if (width > attributes.frame.size.width) {
                width = attributes.frame.size.width;
            } else if (width < 0) {
                width = 0;
            }
            CGFloat x = CGRectGetMidX(attributes.frame) - width / 2.0;
            
            if (animated) {
                __weak typeof(strongSelf) tempWeakSelf = strongSelf;
                [UIView animateWithDuration:0.3 animations:^{
                    __strong typeof(tempWeakSelf) tempStrongSelf = tempWeakSelf;
                    tempStrongSelf.indicatorView.frame = CGRectMake(x, y, width, tempStrongSelf.configuration.indicatorHeight);
                }];
            } else {
                strongSelf.indicatorView.frame = CGRectMake(x, y, width, strongSelf.configuration.indicatorHeight);
            }
        }];
    } else if (!self.itemsArray.count) {
        self.indicatorView.hidden = YES;
    }
}

- (void)calculateWidthWithItem:(SegmentedViewItem *)item atIndex:(NSInteger)index result:(void(^)(CGFloat titleWidth, CGFloat contentWidth))result {
    UIFont *titleFont = index == self.selectedIndex ? _configuration.selectedTitleFont : _configuration.unselectedTitleFont;
    CGFloat titleWidth = [self widthForString:item.title
                                     withFont:titleFont
                              containerHeight:self.bounds.size.height];
    CGFloat contentWidth = titleWidth;
    if (item.badgeImage.imageName.length > 0 && !CGSizeEqualToSize(item.badgeImage.imageSize, CGSizeZero)) {
        contentWidth += (item.badgeImage.imageSize.width + item.badgeOffset.horizontal);
    } else if (item.badgeText.badgeValue.length > 0) {
        // badgeButton insets为(0, 4, 0, 4), so 8 = 4 + 4
        // 14为badgeButton height，10为badgeButton字号大小
        CGFloat badgeValueWidth = [self widthForString:item.badgeText.badgeValue
                                              withFont:[UIFont systemFontOfSize:10]
                                       containerHeight:14];
        if (badgeValueWidth + 8 >= 14) {
            contentWidth += (badgeValueWidth + 8 + item.badgeOffset.horizontal);
        } else {
            contentWidth += (14 + item.badgeOffset.horizontal);
        }
    } else if (item.badgeDot) {
        contentWidth += (item.badgeDot.dotDiameter + item.badgeOffset.horizontal);
    }
    
    if (result) {
        result(titleWidth, contentWidth);
    }
}

#pragma mark 获取字符串的宽度
- (CGFloat)widthForString:(NSString *)textString withFont:(UIFont *)font containerHeight:(CGFloat)containerHeight {
    if ([font isKindOfClass:[UIFont class]] && [textString isKindOfClass:[NSString class]]) {
        NSDictionary *attrs = @{NSFontAttributeName : font};
        CGSize maxSize = CGSizeMake(MAXFLOAT, containerHeight);
        CGFloat calculateWidth = [textString boundingRectWithSize:maxSize
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:attrs
                                                          context:nil].size.width;
        return ceil(calculateWidth);
    } else {
        return 0;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.itemsArray.count > 0) {
        CGFloat validWidth =  self.bounds.size.width - self.configuration.contentLeftMargin - self.configuration.contentRightMargin - self.configuration.itemSpacing * (self.itemsArray.count-1);
        CGFloat itemWidth = validWidth / self.itemsArray.count;
        return CGSizeMake(floor(itemWidth), floor(self.bounds.size.height));
    } else {
        return CGSizeZero;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self setSelectItemAtIndex:indexPath.item animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EWSVCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"segmented view cell" forIndexPath:indexPath];
    SegmentedViewItem *item = self.itemsArray[indexPath.item];
    cell.titleLabel.text = item.title;
    cell.titleLabel.font = self.selectedIndex == indexPath.item ? self.configuration.selectedTitleFont : self.configuration.unselectedTitleFont;
    cell.titleLabel.textColor = self.selectedIndex == indexPath.item ? self.configuration.selectedTitleColor : self.configuration.unselectedTitleColor;
    [cell resetBadge];
    if (item.badgeImage.imageName.length > 0 && !CGSizeEqualToSize(item.badgeImage.imageSize, CGSizeZero)) {
        cell.badgeImageView.hidden = NO;
        cell.badgeImageView.image = [UIImage imageNamed:item.badgeImage.imageName];
        cell.badgeImageViewWidthConstraint.constant = item.badgeImage.imageSize.width;
        cell.badgeImageViewHeightConstraint.constant = item.badgeImage.imageSize.height;
        cell.badgeImageViewLeftConstraint.constant = item.badgeOffset.horizontal;
        cell.badgeImageVieweBottomConstraint.constant = item.badgeOffset.vertical;
    } else if (item.badgeText.badgeValue.length > 0) {
        cell.badgeButton.hidden = NO;
        [cell.badgeButton setTitle:item.badgeText.badgeValue forState:UIControlStateNormal];
        cell.badgeButtonLeftConstraint.constant = item.badgeOffset.horizontal;
        cell.badgeButtonBottomConstraint.constant = item.badgeOffset.vertical;
    } else if (item.badgeDot) {
        cell.badgeImageView.hidden = NO;
        cell.badgeImageView.backgroundColor = [UIColor redColor];
        cell.badgeImageViewWidthConstraint.constant = item.badgeDot.dotDiameter;
        cell.badgeImageViewHeightConstraint.constant = item.badgeDot.dotDiameter;
        cell.badgeImageViewLeftConstraint.constant = item.badgeOffset.horizontal;
        cell.badgeImageVieweBottomConstraint.constant = item.badgeOffset.vertical;
    }
    [cell layoutIfNeeded];
    return cell;
}

#pragma mark - getter or setter
- (UIView *)headerLineView {
    if (!_headerLineView) {
        _headerLineView = [[UIView alloc] init];
    }
    return _headerLineView;
}

- (UIView *)footerLineView {
    if (!_footerLineView) {
        _footerLineView = [[UIView alloc] init];
    }
    return _footerLineView;
}

- (UIView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc] init];
    }
    return _indicatorView;
}

@end
