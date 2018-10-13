//
//  ViewController.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/10/12.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import "ViewController.h"
#import "UIAlertController+CTLHelper.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionInViewInvoke:)]];
}

- (void)tapActionInViewInvoke:(UITapGestureRecognizer *)tap {
    [self.textField resignFirstResponder];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"弹框测试内容"
                                                            preferredStyle:UIAlertControllerStyleAlert
                                                         cancelActionTitle:@"取消"
                                                          otherActionTitle:@"设置", nil];
    alert.alertActionHandler = ^(UIAlertAction * _Nonnull action) {
        
    };
    [self presentViewController:alert
                       animated:YES
                     completion:^{
                         
                     }];
}

@end
