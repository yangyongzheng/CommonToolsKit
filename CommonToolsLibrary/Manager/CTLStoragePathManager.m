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

+ (CTLStorageDirectory)storageDocumentsDirectory {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
}

+ (CTLStorageDirectory)storageLibraryDirectory {
    return NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
}

+ (CTLStorageDirectory)storageCacheDirectory {
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
}

+ (CTLStorageDirectory)storageTempDirectory {
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
        default:
            stringValue = @"Caches";
            break;
    }
    
    return stringValue;
}

+ (NSString *)directoryWithBaseDirectory:(CTLStorageDirectory)baseDirectory relativeSubdirectory:(NSString *)relativeSubdirectory {
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
