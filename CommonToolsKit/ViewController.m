//
//  ViewController.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/10/12.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import "ViewController.h"
#import "UIAlertController+CTLHelper.h"
#import "TwoViewController.h"
#import "NSTimer+CTLBlockTimer.h"

@interface ViewController ()
{
    NSTimer *_timer;
}
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionInViewInvoke:)]];
    
    _timer = [NSTimer ctl_scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"%@", NSHomeDirectory());
    }];
    [_timer fire];
}

- (void)tapActionInViewInvoke:(UITapGestureRecognizer *)tap {
    [self.textField resignFirstResponder];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"弹框测试内容"
                                                            preferredStyle:UIAlertControllerStyleAlert
                                                         cancelActionTitle:@"取消"
                                                          otherActionTitle:@"设置", nil];
    alert.alertActionHandler = ^(UIAlertAction * _Nonnull action) {
        if ([action.title isEqualToString:@"设置"]) {
            [self.navigationController pushViewController:[TwoViewController twoViewController] animated:YES];
        }
    };
    [self presentViewController:alert
                       animated:YES
                     completion:^{
                         
                     }];
}

@end
