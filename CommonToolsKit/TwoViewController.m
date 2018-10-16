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
    
    NSString *filePath = [[CTLStoragePathManager storageTempDirectory] stringByAppendingString:@"test.txt"];
    [NSFileManager.defaultManager createFileAtPath:filePath contents:nil attributes:nil];
    [NSUserDefaults.standardUserDefaults setObject:@"test" forKey:@"com.yyz.test"];
}

- (void)dealloc {
}

@end
