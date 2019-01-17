//
//  TwoViewController.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/10/13.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import "TwoViewController.h"
#import "CommonToolsLibraryHeader.h"
#import "CTLCallMonitor.h"

@interface TwoViewController ()<CTLLocationManagerDelegate, CTLCallMonitorDelegate>
{
    EqualWidthSegmentedView *_segmentedView;
}
@property (nonatomic, strong) CTLCallMonitor *callMonitor;
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
    self.callMonitor = CTLCallMonitor.callMonitor;
    [self.callMonitor startMonitorWithDelegate:self];
}

- (void)dealloc {
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [CTLLocationManager.defaultManager addDelegate:self];
    [CTLLocationManager.defaultManager startUpdatingLocation];
    
    NSString *phoneNumber = @"18207415092";
    [UIApplication.sharedApplication ctl_safeOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phoneNumber]]];
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

- (void)callMonitor:(CTLCallMonitor *)callMonitor callChanged:(CTLCallInfo *)callInfo {
    if (callInfo.hasConnected && callInfo.hasEnded) {
        NSLog(@"挂断");
    } else if (callInfo.hasConnected && !callInfo.hasEnded) {
        NSLog(@"已接通");
    } else if (!callInfo.hasConnected && callInfo.hasEnded) {
        NSLog(callInfo.isOutgoing?@"主叫方：挂断":@"被叫方：接听超时");
    } else if (!callInfo.hasConnected && !callInfo.hasEnded) {
        NSLog(callInfo.isOutgoing?@"主叫方：正在拨打":@"被叫方：来电话了，准备接听");
    }
}

@end
