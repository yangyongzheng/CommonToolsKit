//
//  CTLDevice.h
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/11/5.
//  Copyright © 2018 yangyongzheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CTLDevice : NSObject
// 获取单例
@property(class, nonatomic, readonly) CTLDevice *currentDevice;

@property (nonatomic, readonly, copy) NSString *firmwareIdentifier;     // 固件标识符，如iPhone X的标识符为 iPhone10,3 或 iPhone10,6
@property (nonatomic, readonly, copy) NSString *SIMOperator;            // SIM运营商
@property (nonatomic, readonly) CGSize screenResolution;                // 屏幕分辨率
@property (nonatomic, readonly) int64_t diskTotalSpace;                 // 磁盘总空间，单位bytes(字节)
@property (nonatomic, readonly) int64_t diskFreeSpace;                  // 磁盘剩余空间，单位bytes(字节)
@property (nonatomic, readonly) int64_t diskUsedSpace;                  // 磁盘已用空间，单位bytes(字节)
@property (nonatomic, readonly) BOOL isJailBreak;                       // 是否越狱
@property (nonatomic, readonly) BOOL isSimulator;                       // 是否是模拟器
@property (nonatomic, readonly, copy) NSString *dSYMUUIDString;         // dSYM UUID String
@property (nonatomic, readonly) long slideAddress;                      // slide address
@property (nonatomic, readonly, copy) NSString *CPUType;                // CPU Type
@property (nonatomic, readonly, copy) NSString *currentLanguage;        // 设备当前语言

@property (nonatomic, readonly) BOOL hasBangs;                          // 是否有刘海, 支持横竖屏
@property (nonatomic, readonly) CGFloat additionalSafeAreaBottomMargin; // 有刘海的设备竖屏时为34.0，横屏21.0

// 版本判断
@property (nonatomic, readonly) BOOL isiOS8Later;
@property (nonatomic, readonly) BOOL isiOS9Later;
@property (nonatomic, readonly) BOOL isiOS10Later;
@property (nonatomic, readonly) BOOL isiOS11Later;
@property (nonatomic, readonly) BOOL isiOS12Later;

// 将字节数转换为 file or storage byte counts string
+ (NSString *)stringFromFileOrStorageFormatByteCount:(int64_t)byteCount;
// 将字节数转换为 memory byte counts string
+ (NSString *)stringFromMemoryFormatByteCount:(int64_t)byteCount;

@end

NS_ASSUME_NONNULL_END
