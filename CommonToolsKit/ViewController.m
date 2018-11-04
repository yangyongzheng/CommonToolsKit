//
//  ViewController.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/10/12.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import "ViewController.h"
#import "TwoViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIApplication.sharedApplication.statusBarHidden = YES;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionInViewInvoke:)]];
    self.view.backgroundColor = CTLColorWithHexString(@"66bb47");
    self.view.backgroundColor = CTLColorWithHexInt(0x55bb22);
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
        } else {
            NSLog(@"%f-%f", CTLSafeAreaManager.defaultManager.safeAreaTopMargin, CTLSafeAreaManager.defaultManager.safeAreaBottomMargin);
            NSLog(@"%@", self.textField.text.ctl_MD5);
            NSLog(@"%@", self.textField.text.ctl_MD5AddSalt);
        }
    };
    [self presentViewController:alert
                       animated:YES
                     completion:^{
                         
                     }];
}

@end
