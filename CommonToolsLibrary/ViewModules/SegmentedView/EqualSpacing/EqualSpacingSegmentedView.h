//
//  EqualSpacingSegmentedView.h
//  YZKit
//
//  Created by 杨永正 on 2018/8/27.
//  Copyright © 2018 yangyongzheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SegmentedViewConfiguration.h"
#import "SegmentedViewItem.h"


@class EqualSpacingSegmentedView;

@protocol EqualSpacingSegmentedViewDelegate <NSObject>
- (void)equalSpacingSegmentedView:(EqualSpacingSegmentedView *)segmentedView
                    didSelectItem:(SegmentedViewItem *)selectItem
                          atIndex:(NSUInteger)index;
@end

@interface EqualSpacingSegmentedView : UIView
@property (nonatomic, readonly, strong) UIView *headerLineView; // default hidden
@property (nonatomic, readonly, strong) UIView *footerLineView; // default show
@property (nonatomic, readonly, strong) UIView *indicatorView;  // default show

@property (nonatomic, readonly, copy) NSArray<SegmentedViewItem *> *itemsArray;
@property (nonatomic, readonly, strong) SegmentedViewConfiguration *configuration;
@property (nonatomic, weak) id <EqualSpacingSegmentedViewDelegate> delegate;

@property (nonatomic, readonly) NSInteger currentSelectedIndex;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame
                        items:(NSArray<SegmentedViewItem *> *)items
                configuration:(SegmentedViewConfiguration *)configuration
                     delegate:(id<EqualSpacingSegmentedViewDelegate>)delegate NS_DESIGNATED_INITIALIZER;
/**
 初始化方法
 
 @param frame frame
 @param items 标题数组
 @param index 默认选中下标为index的item
 @param configuration 配置
 @param delegate 代理
 @return 返回实例
 */
- (instancetype)initWithFrame:(CGRect)frame
                        items:(NSArray<SegmentedViewItem *> *)items
            selectItemAtIndex:(NSUInteger)index
                configuration:(SegmentedViewConfiguration *)configuration
                     delegate:(id<EqualSpacingSegmentedViewDelegate>)delegate NS_DESIGNATED_INITIALIZER;

/**
 设置选中下标为index的item, 如是初始化设置选中item请使用上面方法.
 
 @param index 设置选中下标为 index的item
 */
- (void)setSelectItemAtIndex:(NSUInteger)index animated:(BOOL)animated;

/**
 设置选中下标为index的item
 
 @param index 待选中item index
 @param animated 是否动画
 @param invokeDelegateMethod 是否调用代理方法
 */
- (void)setSelectItemAtIndex:(NSUInteger)index
                    animated:(BOOL)animated
        invokeDelegateMethod:(BOOL)invokeDelegateMethod;

/** 更新所有item */
- (void)updateSegmentedViewItems:(NSArray<SegmentedViewItem *> *)items;

/** 更新下标为index的item */
- (void)updateSegmentedViewItem:(SegmentedViewItem *)item atIndex:(NSInteger)index;
@end
