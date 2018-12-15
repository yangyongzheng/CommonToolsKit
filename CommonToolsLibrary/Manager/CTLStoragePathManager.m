//
//  CTLStoragePathManager.m
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/10/15.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import "CTLStoragePathManager.h"
#import <CommonCrypto/CommonDigest.h>

#define CTLStorageSubBaseDirectory CTLSPMMD5Encrypt(@"com.ctl.storage.subBaseDirectory")

static NSString *CTLSPMMD5Encrypt(NSString *sourceString) {
    if (sourceString && [sourceString isKindOfClass:[NSString class]]) {
        const char *cStr = sourceString.UTF8String;
        unsigned char digest[CC_MD5_DIGEST_LENGTH];
        CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
        
        NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
        for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
            [output appendFormat:@"%02X", digest[i]];
        }
        
        return [output copy];
    }
    
    return nil;
}

static NSString *__CTLRelativeSubdirectory(CTLStoragePathSubdirectory subdirectory) {
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
    
    return stringValue ? [CTLStorageSubBaseDirectory stringByAppendingPathComponent:stringValue] : CTLStorageSubBaseDirectory;
}

NSString *CTLStoragePathForBaseDirectory(CTLStoragePathBaseDirectory baseDirectory) {
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
    
    return baseDirPath ? baseDirPath : (NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject);
}

NSString *CTLStoragePathForBaseSubdirectory(CTLStoragePathBaseDirectory baseDirectory,
                                            CTLStoragePathSubdirectory subdirectory) {
    NSString *baseDirPath = CTLStoragePathForBaseDirectory(baseDirectory);
    NSString *absoluteDirPath = [baseDirPath stringByAppendingPathComponent:__CTLRelativeSubdirectory(subdirectory)];
    if (absoluteDirPath.length > 0 && ![NSFileManager.defaultManager fileExistsAtPath:absoluteDirPath isDirectory:NULL]) {
        [NSFileManager.defaultManager createDirectoryAtPath:absoluteDirPath
                                withIntermediateDirectories:YES
                                                 attributes:nil
                                                      error:nil];
    }
    
    return absoluteDirPath;
}

NSString *CTLStoragePathForDirectory(CTLStoragePathBaseDirectory baseDirectory,
                                     CTLStoragePathSubdirectory subdirectory,
                                     NSString *relativeSubdirectory) {
    NSString *baseDirPath = CTLStoragePathForBaseSubdirectory(baseDirectory, subdirectory);
    NSString *absoluteDirPath = baseDirPath;
    if (relativeSubdirectory && [relativeSubdirectory isKindOfClass:[NSString class]] && relativeSubdirectory.length > 0) {
        absoluteDirPath = [baseDirPath stringByAppendingPathComponent:relativeSubdirectory];
        if (absoluteDirPath.length > 0 && ![NSFileManager.defaultManager fileExistsAtPath:absoluteDirPath isDirectory:NULL]) {
            [NSFileManager.defaultManager createDirectoryAtPath:absoluteDirPath
                                    withIntermediateDirectories:YES
                                                     attributes:nil
                                                          error:nil];
        }
    }
    
    return absoluteDirPath;
}

NSString *CTLStoragePathForFileInDirectory(NSString *fileFullName, NSString *directoryPath) {
    NSString *filePath = [directoryPath stringByAppendingPathComponent:fileFullName];
    NSString *dirPath = [filePath stringByDeletingLastPathComponent];
    if (![NSFileManager.defaultManager fileExistsAtPath:dirPath isDirectory:NULL]) {
        [NSFileManager.defaultManager createDirectoryAtPath:dirPath
                                withIntermediateDirectories:YES
                                                 attributes:nil
                                                      error:nil];
    }
    
    return filePath;
}
