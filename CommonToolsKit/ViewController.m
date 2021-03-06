//
//  ViewController.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/10/12.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import "ViewController.h"
#import "TwoViewController.h"
#import "CommonToolsLibraryHeader.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIApplication.sharedApplication.statusBarHidden = YES;
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
        if ([action.title isEqualToString:@"设置"]) {
            [self.navigationController pushViewController:[TwoViewController twoViewController] animated:YES];
        } else {
            NSLog(@"%f-%f", CTLSafeAreaTopMargin, CTLSafeAreaBottomMargin);
            NSLog(@"%@", self.textField.text.ctl_MD5);
            NSLog(@"%@", self.textField.text.ctl_MD5AddSalt);
        }
    };
    [self presentViewController:alert
                       animated:YES
                     completion:^{
                         
                     }];
    
    NSLog(@"%@", CTLDevice.currentDevice.firmwareIdentifier);
    NSLog(@"%f", CTLCompileTimestamp);
    NSLog(@"%@", [CTLDevice stringFromFileOrStorageFormatByteCount:CTLDevice.currentDevice.diskTotalSpace]);
    NSLog(@"%@", [CTLDevice stringFromFileOrStorageFormatByteCount:CTLDevice.currentDevice.diskFreeSpace]);
    NSLog(@"%@", [CTLDevice stringFromFileOrStorageFormatByteCount:CTLDevice.currentDevice.diskUsedSpace]);
    NSLog(@"%@", CTLDevice.currentDevice.dSYMUUIDString);
    NSLog(@"%ld", CTLDevice.currentDevice.slideAddress);
    NSLog(@"%@", CTLDevice.currentDevice.CPUType);
    NSLog(@"%@", CTLDevice.currentDevice.currentLanguage);
}

@end
