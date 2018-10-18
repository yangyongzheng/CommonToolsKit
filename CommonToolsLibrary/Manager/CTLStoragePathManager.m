//
//  CTLStoragePathManager.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/10/15.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import "CTLStoragePathManager.h"

#define CTLStorageRootDirectoryName [NSBundle.mainBundle.bundleIdentifier stringByAppendingString:@".CTLStorageRoot"]

static NSString *CTLRelativeSubdirectory(CTLStoragePathSubdirectory subdirectory) {
    NSString *stringValue = nil;
    switch (subdirectory) {
        case CTLStorageDatabasesSubdirectory:
            stringValue = @"Databases";
            break;
            
        case CTLStorageArchivesSubdirectory:
            stringValue = @"Archives";
            break;
            
        case CTLStorageCachesSubdirectory:
            stringValue = @"Caches";
            break;
            
        case CTLStorageOthersSubdirectory:
            stringValue = @"Others";
            break;
    }
    
    return [CTLStorageRootDirectoryName stringByAppendingPathComponent:stringValue];
}

NSString *CTLStoragePathForDirectory(CTLStoragePathBaseDirectory baseDirectory, CTLStoragePathSubdirectory subdirectory) {
    NSString *baseDirPath = nil;
    switch (baseDirectory) {
        case CTLStorageDocumentsBaseDirectory:
            baseDirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
            break;
            
        case CTLStorageLibraryBaseDirectory:
            baseDirPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
            break;
            
        case CTLStorageCachesBaseDirectory:
            baseDirPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
            break;
            
        case CTLStorageTempBaseDirectory:
            baseDirPath = NSTemporaryDirectory();
            break;
    }
    
    NSString *absoluteDirPath = [baseDirPath stringByAppendingPathComponent:CTLRelativeSubdirectory(subdirectory)];
    if (absoluteDirPath.length > 0 && ![NSFileManager.defaultManager fileExistsAtPath:absoluteDirPath isDirectory:NULL]) {
        [NSFileManager.defaultManager createDirectoryAtPath:absoluteDirPath
                                withIntermediateDirectories:YES
                                                 attributes:nil
                                                      error:nil];
    }
    
    return absoluteDirPath;
}

NSString *CTLStoragePathForFileInDirectory(NSString *fileFullName, NSString *directoryPath) {
    NSString *filePath = [directoryPath stringByAppendingPathComponent:fileFullName];
    NSString *directory = [filePath stringByDeletingLastPathComponent];
    if (![NSFileManager.defaultManager fileExistsAtPath:directory isDirectory:NULL]) {
        [NSFileManager.defaultManager createDirectoryAtPath:directory
                                withIntermediateDirectories:YES
                                                 attributes:nil
                                                      error:nil];
    }
    
    return filePath;
}
