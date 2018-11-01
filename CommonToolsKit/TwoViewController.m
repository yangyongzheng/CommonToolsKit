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
    
    NSString *dirPath = CTLStoragePathForDirectory(CTLStorageDocumentsBaseDirectory, CTLStorageArchivesSubdirectory);
    NSString *filePath = CTLStoragePathForFileInDirectory(@"User.archive", dirPath);
    [NSKeyedArchiver archiveRootObject:@"test" toFile:filePath];
}

- (void)dealloc {
}

@end
