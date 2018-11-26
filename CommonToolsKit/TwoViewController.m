//
//  TwoViewController.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/10/13.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import "TwoViewController.h"
#import "CommonToolsLibraryHeader.h"

@interface TwoViewController ()<EqualWidthSegmentedViewDelegate>
{
    EqualWidthSegmentedView *_segmentedView;
}
@end

@implementation TwoViewController

+ (instancetype)twoViewController {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle];
    return [sb instantiateViewControllerWithIdentifier:@"TwoViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = CTLColorWithHexInt(0xf5f5f5);
    
    SegmentedViewItem *item = [SegmentedViewItem itemWithTitle:@"首页"];
    SegmentedViewItem *item2 = [SegmentedViewItem itemWithTitle:@"我要买"];
    SegmentedViewItem *item3 = [SegmentedViewItem itemWithTitle:@"我要卖"];
    _segmentedView = [[EqualWidthSegmentedView alloc] initWithFrame:CGRectMake(0, CTLSafeAreaTopMargin, CTLScreenWidth, 40)
                                                              items:@[item, item2, item3]
                                                      configuration:SegmentedViewConfiguration.defaultConfiguration
                                                           delegate:self];
    [self.view addSubview:_segmentedView];
    
    [_segmentedView setSelectItemAtIndex:1 animated:NO];
}

- (void)equalWidthSegmentedView:(EqualWidthSegmentedView *)segmentedView
                  didSelectItem:(SegmentedViewItem *)selectItem
                        atIndex:(NSUInteger)index {
    NSLog(@"index: %ld", index);
}

- (void)dealloc {
    
}

@end
