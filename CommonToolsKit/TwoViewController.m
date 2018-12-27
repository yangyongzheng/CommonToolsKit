//
//  TwoViewController.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/10/13.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import "TwoViewController.h"
#import "CommonToolsLibraryHeader.h"
#import "CTLTimerHolder.h"
#import "NSTimer+CTLBlockTimer.h"

@interface TwoViewController ()<CTLLocationManagerDelegate>
{
    EqualWidthSegmentedView *_segmentedView;
    CTLTimerHolder *_timerHolder;
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
    _timerHolder = [[CTLTimerHolder alloc] init];
}

- (void)dealloc {
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
 
    [_timerHolder startTimerWithCountdown:60 interval:1 block:^(CTLTimerHolder * _Nonnull timerHolder, NSTimeInterval currentCountdown) {
        NSLog(@"%f", currentCountdown);
    }];
    [_timerHolder startFire];
    
    [CTLLocationManager.defaultManager addDelegate:self];
    [CTLLocationManager.defaultManager startUpdatingLocation];
}

#pragma mark - CTLLocationManagerDelegate
- (void)locationManager:(CTLLocationManager *)manager didUpdateLocation:(CLLocation *)location {
    NSLog(@"%@", location);
}

- (void)locationManager:(CTLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}

- (void)locationManager:(CTLLocationManager *)manager reverseGeocodeLocation:(CTLLocationInfo *)locationInfo error:(NSError *)error {
    if (locationInfo) {
        NSLog(@"%@", locationInfo.fullAddress);
    } else {
        NSLog(@"%@", error);
    }
}

#pragma mark - CTLTimerHolderDelegate
- (void)timerHolderFired:(CTLTimerHolder *)timerHolder {
    NSLog(@"coming...");
}

- (void)timerHolder:(CTLTimerHolder *)timerHolder countdown:(NSTimeInterval)countdown {
    
}

@end
