//
//  CTLDevice.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/11/5.
//  Copyright © 2018 yangyongzheng. All rights reserved.
//

#import "CTLDevice.h"
#import <sys/utsname.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <dlfcn.h>
#import <sys/stat.h>

@interface CTLDevice ()
@property (nonatomic, readonly) UIEdgeInsets safeAreaInsets;
@end

@implementation CTLDevice

+ (CTLDevice *)currentDevice {
    static CTLDevice *device = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        device = [[CTLDevice alloc] init];
        [device loadDefaultConfiguration];
    });
    
    return device;
}

- (NSString *)deviceModelIdentifier {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

- (NSString *)SIMOperator {
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = networkInfo.subscriberCellularProvider;
    return carrier.carrierName;
}

- (CGSize)screenResolution {
    CGSize size = UIScreen.mainScreen.bounds.size;
    CGFloat scale = UIScreen.mainScreen.scale;
    return CGSizeMake(size.width * scale,
                      size.height * scale);
}

- (CGFloat)additionalSafeAreaBottomMargin {
    return self.safeAreaInsets.bottom;
}

- (int64_t)diskTotalSpace {
    NSError *error = nil;
    NSDictionary *attrs = [NSFileManager.defaultManager attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) {return -1;}
    int64_t space =  [[attrs objectForKey:NSFileSystemSize] longLongValue];
    if (space < 0) {space = -1;}
    return space;
}

- (int64_t)diskFreeSpace {
    NSError *error = nil;
    NSDictionary *attrs = [NSFileManager.defaultManager attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) {return -1;}
    int64_t space =  [[attrs objectForKey:NSFileSystemFreeSize] longLongValue];
    if (space < 0) {space = -1;}
    return space;
}

- (int64_t)diskUsedSpace {
    int64_t totalSize = self.diskTotalSpace;
    int64_t freeSize = self.diskFreeSpace;
    if (totalSize < 0 || freeSize < 0) {return -1;}
    int64_t usedSize = totalSize - freeSize;
    if (usedSize < 0) {usedSize = -1;}
    return usedSize;
}

- (BOOL)isJailBreak {
    // 方式1.判断是否存在越狱工具文件
    NSArray *jailbreak_tool_paths = @[@"/Applications/Cydia.app",
                                      @"/Library/MobileSubstrate/MobileSubstrate.dylib",
                                      @"/bin/bash",
                                      @"/usr/sbin/sshd",
                                      @"/etc/apt"];
    for (NSString *path in jailbreak_tool_paths) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            return YES;
        }
    }
    // 方式2.判断是否存在cydia应用
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://"]]){
        return YES;
    }
    // 方式3.读取系统所有的应用名称
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/User/Applications/"]){
        return YES;
    }
    // 方式4.根据使用stat方法来判断cydia是否存在来判断
    if (ctl_jailbreakCheckCydia() == 1) {
        return YES;
    }
    // 方式5.读取环境变量
    char *env = getenv("DYLD_INSERT_LIBRARIES");
    if (env) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isSimulator {
#if TARGET_IPHONE_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

#pragma mark - 版本判断
- (BOOL)isiOS8Later {
    if (@available(iOS 8.0, *)) {
        return YES;
    }
    return NO;
}

- (BOOL)isiOS9Later {
    if (@available(iOS 9.0, *)) {
        return YES;
    }
    return NO;
}

- (BOOL)isiOS10Later {
    if (@available(iOS 10.0, *)) {
        return YES;
    }
    return NO;
}

- (BOOL)isiOS11Later {
    if (@available(iOS 11.0, *)) {
        return YES;
    }
    return NO;
}

- (BOOL)isiOS12Later {
    if (@available(iOS 12.0, *)) {
        return YES;
    }
    return NO;
}

#pragma mark 存储单位转换
#pragma mark 将字节数转换为 file or storage byte counts string
+ (NSString *)stringFromFileOrStorageFormatByteCount:(int64_t)byteCount {
    return [NSByteCountFormatter stringFromByteCount:byteCount countStyle:NSByteCountFormatterCountStyleFile];
}

#pragma mark 将字节数转换为 memory byte counts string
+ (NSString *)stringFromMemoryFormatByteCount:(int64_t)byteCount {
    return [NSByteCountFormatter stringFromByteCount:byteCount countStyle:NSByteCountFormatterCountStyleMemory];
}

#pragma mark - Misc
- (void)loadDefaultConfiguration {
    UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        UIWindow *tmpWindow = UIApplication.sharedApplication.keyWindow;
        if (!tmpWindow) {
            tmpWindow = UIApplication.sharedApplication.windows.firstObject;
        }
        safeAreaInsets = tmpWindow.safeAreaInsets;
    }
    
    self->_hasBangs = safeAreaInsets.bottom > 20;// 横向时 有刘海设备的bottomMargin为 21.0
    self->_safeAreaInsets = safeAreaInsets;
}

#pragma mark 根据使用stat方法来判断cydia是否存在来判断
static int ctl_jailbreakCheckInject() {
    int ret;
    Dl_info dylib_info;
    int (*func_stat)(const char*, struct stat*) = stat;
    char *dylib_name = "/usr/lib/system/libsystem_kernel.dylib";
    if ((ret = dladdr(func_stat, &dylib_info)) && strncmp(dylib_info.dli_fname, dylib_name, strlen(dylib_name))) {
        return 0;
    }
    return 1;
}

static int ctl_jailbreakCheckCydia() {
    struct stat stat_info;
    if (!ctl_jailbreakCheckInject()) {
        if (0 == stat("/Applications/Cydia.app", &stat_info)) {
            return 1;
        }
    } else {
        return 1;
    }
    return 0;
}

@end
