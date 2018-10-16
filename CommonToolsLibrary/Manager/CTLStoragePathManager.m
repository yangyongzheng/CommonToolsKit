//
//  CTLStoragePathManager.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/10/15.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import "CTLStoragePathManager.h"

typedef NS_ENUM(NSUInteger, CTLStorageType) {
    CTLStorageTypeDatabase,     // 数据库存储
    CTLStorageTypeNetworkData,  // 网络数据
    CTLStorageTypeArchive,      // 归档存储
};

@implementation CTLStoragePathManager

+ (NSString *)storageHomeDirectory {
    return NSHomeDirectory();
}

+ (NSString *)storageDocumentsDirectory {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
}

+ (NSString *)storageLibraryDirectory {
    return NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
}

+ (NSString *)storageCacheDirectory {
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
}

+ (NSString *)storageTempDirectory {
    return NSTemporaryDirectory();
}



@end
