//
//  TwoViewController.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/10/13.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import "TwoViewController.h"
#import "CTLStoragePathManager.h"
#import "NSTimer+CTLBlockTimer.h"

@interface TwoViewController ()
{
    NSTimer *_timer;
    NSTimer *_countdownTimer;
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
    
    _timer = [NSTimer ctl_scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"%@", [CTLStoragePathManager storageTempDirectory]);
    }];
    [_timer fire];
}

- (void)dealloc {
    [_timer invalidate];
}

@end
