//
//  CTLStoragePathManager.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/10/15.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import "CTLStoragePathManager.h"

#define CTLStorageRootDirectoryName [NSBundle.mainBundle.bundleIdentifier stringByAppendingString:@".ctl_storage_root"]

@implementation CTLStoragePathManager

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

+ (NSString *)stringWithStorageType:(CTLStorageType)storageType {
    NSString *stringValue = nil;
    switch (storageType) {
        case CTLStorageTypeDatabases:
            stringValue = @"Databases";
            break;
        case CTLStorageTypeArchives:
            stringValue = @"Archives";
            break;
        case CTLStorageTypeCaches:
            stringValue = @"Caches";
            break;
        default:
            stringValue = @"Others";
            break;
    }
    
    return stringValue;
}

+ (NSString *)directoryWithBaseDirectory:(NSString *)baseDirectory relativeSubdirectory:(NSString *)relativeSubdirectory {
    NSString *directoryPath = nil;
    if (baseDirectory && [baseDirectory isKindOfClass:[NSString class]] && baseDirectory.length > 0) {
        directoryPath = baseDirectory;
    } else {
        directoryPath = CTLStoragePathManager.storageDocumentsDirectory;
    }
    if (relativeSubdirectory && [relativeSubdirectory isKindOfClass:[NSString class]] && relativeSubdirectory.length > 0) {
        directoryPath = [directoryPath stringByAppendingPathComponent:relativeSubdirectory];
    }
    if (![NSFileManager.defaultManager fileExistsAtPath:directoryPath isDirectory:NULL]) {
        [NSFileManager.defaultManager createDirectoryAtPath:directoryPath
                                withIntermediateDirectories:YES
                                                 attributes:nil
                                                      error:nil];
    }
    
    return directoryPath;
}

+ (NSString *)relativeSubdirectoryWithStorageType:(CTLStorageType)storageType {
    return [CTLStorageRootDirectoryName stringByAppendingPathComponent:[self stringWithStorageType:storageType]];
}

@end
