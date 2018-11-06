//
//  TwoViewController.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/10/13.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import "TwoViewController.h"
#import "CommonToolsLibraryHeader.h"

@interface TwoViewController ()
{
    dispatch_source_t _timer;
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
    
    self.view.backgroundColor = CTLColorWithHexInt(0x55bb22);
}

- (void)dealloc {
}

@end
