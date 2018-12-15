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
#import <mach-o/dyld.h>
#include <mach/mach_host.h>

static NSString * const CTLDeviceLastVersion = @"CTLDeviceLastVersion";
static NSString * const CTLDeviceIsUpgtadeInstallation = @"CTLDeviceIsUpgtadeInstallation";

@interface CTLDevice ()
@property (nonatomic, readonly) UIEdgeInsets safeAreaInsets;
@end

@implementation CTLDevice

- (instancetype)init {
    self = [super init];
    if (self) {
        [self __loadDefaultConfiguration];
    }
    return self;
}

+ (CTLDevice *)currentDevice {
    static CTLDevice *device = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        device = [[CTLDevice alloc] init];
    });
    
    return device;
}

- (void)startConfiguration {
    
}

- (NSString *)firmwareIdentifier {
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

- (NSString *)dSYMUUIDString {
    const struct mach_header *executableHeader = NULL;
    for (uint32_t i = 0; i < _dyld_image_count(); i++) {
        const struct mach_header *header = _dyld_get_image_header(i);
        if (header->filetype == MH_EXECUTE) {
            executableHeader = header;
            break;
        }
    }
    
    if (!executableHeader) {
        return nil;
    }
    
    BOOL is64bit = executableHeader->magic == MH_MAGIC_64 || executableHeader->magic == MH_CIGAM_64;
    uintptr_t cursor = (uintptr_t)executableHeader + (is64bit ? sizeof(struct mach_header_64) : sizeof(struct mach_header));
    const struct segment_command *segmentCommand = NULL;
    for (uint32_t i = 0; i < executableHeader->ncmds; i++, cursor += segmentCommand->cmdsize) {
        segmentCommand = (struct segment_command *)cursor;
        if (segmentCommand->cmd == LC_UUID) {
            const struct uuid_command *uuidCommand = (const struct uuid_command *)segmentCommand;
            return [[NSUUID alloc] initWithUUIDBytes:uuidCommand->uuid].UUIDString;
        }
    }
    
    return nil;
}

- (long)slideAddress {
    long slide = 0;
    for (uint32_t i = 0; i < _dyld_image_count(); i++) {
        if (_dyld_get_image_header(i)->filetype == MH_EXECUTE) {
            slide = _dyld_get_image_vmaddr_slide(i);
            break;
        }
    }
    return slide;
}

- (NSString *)CPUType {
    host_basic_info_data_t hostInfo;
    mach_msg_type_number_t infoCount;
    
    infoCount = HOST_BASIC_INFO_COUNT;
    host_info(mach_host_self(), HOST_BASIC_INFO, (host_info_t)&hostInfo, &infoCount);
    
    NSString *cpuType = nil;
    if (hostInfo.cpu_type == CPU_TYPE_ANY) {
        cpuType = @"CPU_TYPE_ANY";
    } else if (hostInfo.cpu_type == CPU_TYPE_VAX) {
        cpuType = @"CPU_TYPE_VAX";
    } else if (hostInfo.cpu_type == CPU_TYPE_MC680x0) {
        cpuType = @"CPU_TYPE_MC680x0";
    } else if (hostInfo.cpu_type == CPU_TYPE_X86) {
        cpuType = @"CPU_TYPE_X86";
    } else if (hostInfo.cpu_type == CPU_TYPE_I386) {
        cpuType = @"CPU_TYPE_X86";
    } else if (hostInfo.cpu_type == CPU_TYPE_X86_64) {
        cpuType = @"CPU_TYPE_X86_64";
    } else if (hostInfo.cpu_type == CPU_TYPE_MC98000) {
        cpuType = @"CPU_TYPE_MC98000";
    } else if (hostInfo.cpu_type == CPU_TYPE_HPPA) {
        cpuType = @"CPU_TYPE_HPPA";
    } else if (hostInfo.cpu_type == CPU_TYPE_ARM) {
        cpuType = @"CPU_TYPE_ARM";
    } else if (hostInfo.cpu_type == CPU_TYPE_ARM64) {
        cpuType = @"CPU_TYPE_ARM64";
    } else if (hostInfo.cpu_type == CPU_TYPE_ARM64_32) {
        cpuType = @"CPU_TYPE_ARM64_32";
    } else if (hostInfo.cpu_type == CPU_TYPE_MC88000) {
        cpuType = @"CPU_TYPE_MC88000";
    } else if (hostInfo.cpu_type == CPU_TYPE_SPARC) {
        cpuType = @"CPU_TYPE_SPARC";
    } else if (hostInfo.cpu_type == CPU_TYPE_I860) {
        cpuType = @"CPU_TYPE_I860";
    } else if (hostInfo.cpu_type == CPU_TYPE_POWERPC) {
        cpuType = @"CPU_TYPE_POWERPC";
    } else if (hostInfo.cpu_type == CPU_TYPE_POWERPC64) {
        cpuType = @"CPU_TYPE_POWERPC64";
    } else {
        cpuType = [@"CPU_TYPE_" stringByAppendingString:[NSString stringWithFormat:@"%d", hostInfo.cpu_type]];
    }
    
    return cpuType;
}

- (NSString *)currentLanguage {
    NSString *language = [NSLocale preferredLanguages].firstObject;
    if (!language) {
        NSArray *languages = [NSUserDefaults.standardUserDefaults arrayForKey:@"AppleLanguages"];
        language = languages.firstObject;
    }
    
    return language;
}

- (BOOL)isUpgtadeInstallation {
    return [NSUserDefaults.standardUserDefaults boolForKey:CTLDeviceIsUpgtadeInstallation];
}

#pragma mark - 存储单位转换
#pragma mark 将字节数转换为 file or storage byte counts string
+ (NSString *)stringFromFileOrStorageFormatByteCount:(int64_t)byteCount {
    return [NSByteCountFormatter stringFromByteCount:byteCount countStyle:NSByteCountFormatterCountStyleFile];
}

#pragma mark 将字节数转换为 memory byte counts string
+ (NSString *)stringFromMemoryFormatByteCount:(int64_t)byteCount {
    return [NSByteCountFormatter stringFromByteCount:byteCount countStyle:NSByteCountFormatterCountStyleMemory];
}

#pragma mark - Misc
- (void)__loadDefaultConfiguration {
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
    // 更新安装模式
    [self updateInstallMode];
}

- (void)updateInstallMode {
    NSUserDefaults *userDefaults = NSUserDefaults.standardUserDefaults;
    NSString *lastVersion = [userDefaults stringForKey:CTLDeviceLastVersion];
    NSString *appVersion = [NSBundle.mainBundle.infoDictionary objectForKey:@"CFBundleShortVersionString"];
    if (lastVersion == nil) {
        [userDefaults setBool:NO forKey:CTLDeviceIsUpgtadeInstallation];
        [userDefaults setObject:appVersion forKey:CTLDeviceLastVersion];
        [userDefaults synchronize];
    } else if (lastVersion != appVersion) {
        [userDefaults setBool:YES forKey:CTLDeviceIsUpgtadeInstallation];
        [userDefaults setObject:appVersion forKey:CTLDeviceLastVersion];
        [userDefaults synchronize];
    }
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
