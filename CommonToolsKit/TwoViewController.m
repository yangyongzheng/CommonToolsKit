//
//  TwoViewController.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/10/13.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import "TwoViewController.h"
#import "CommonToolsLibraryHeader.h"

@interface TwoViewController ()<CTLLocationManagerDelegate>
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
}

- (void)dealloc {
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [CTLLocationManager.defaultManager addDelegate:self];
    [CTLLocationManager.defaultManager startUpdatingLocation];
    
    [UIApplication.sharedApplication ctl_safeOpenURL:[NSURL URLWithString:@"tel:18207415092"]];
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

@end
