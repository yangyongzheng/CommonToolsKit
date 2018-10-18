//
//  CTLStoragePathManager.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/10/15.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import "CTLStoragePathManager.h"

#define CTLStorageRootDirectoryName [NSBundle.mainBundle.bundleIdentifier stringByAppendingString:@".ctl_storage_root"]

static NSString *CTLRelativeSubdirectoryWithType(CTLStorageType storageType) {
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
            
        case CTLStorageTypeOthers:
            stringValue = @"Others";
            break;
    }
    
    return [CTLStorageRootDirectoryName stringByAppendingPathComponent:stringValue];
}

NSString *CTLStoragePathDirectoryWithType(CTLStoragePathDirectory directory, CTLStorageType storageType) {
    NSString *baseDirPath = nil;
    switch (directory) {
        case CTLStorageDocumentsDirectory:
            baseDirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
            break;
            
        case CTLStorageLibraryDirectory:
            baseDirPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
            break;
            
        case CTLStorageCachesDirectory:
            baseDirPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
            break;
    }
    
    NSString *absoluteDirPath = [baseDirPath stringByAppendingPathComponent:CTLRelativeSubdirectoryWithType(storageType)];
    if (absoluteDirPath.length > 0) {
        if ([NSFileManager.defaultManager fileExistsAtPath:absoluteDirPath isDirectory:NULL]) {
            
        }
    }
}
