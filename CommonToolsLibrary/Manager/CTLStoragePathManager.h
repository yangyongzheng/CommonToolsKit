//
//  CTLStoragePathManager.h
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/10/15.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CTLStoragePathSubdirectory) {
    CTLStorageDatabasesSubdirectory,    // Databases
    CTLStorageArchivesSubdirectory,     // Archives
    CTLStorageCachesSubdirectory,       // Caches
    CTLStorageOthersSubdirectory,       // Others
};

typedef NS_ENUM(NSUInteger, CTLStoragePathBaseDirectory) {
    CTLStorageDocumentsBaseDirectory,   // ~/Documents
    CTLStorageLibraryBaseDirectory,     // ~/Library
    CTLStorageCachesBaseDirectory,      // ~/Library/Caches
    CTLStorageTempBaseDirectory,        // ~/tmp
};


/**
 获取目录绝对路径

 @param baseDirectory 基目录类型
 @return 目录绝对路径
 */
FOUNDATION_EXPORT NSString *CTLStoragePathForBaseDirectory(CTLStoragePathBaseDirectory baseDirectory);

/**
 获取目录绝对路径

 @param baseDirectory 基目录类型
 @param subdirectory 子目录类型
 @return 目录绝对路径
 */
FOUNDATION_EXPORT NSString *CTLStoragePathForBaseSubdirectory(CTLStoragePathBaseDirectory baseDirectory,
                                                              CTLStoragePathSubdirectory subdirectory);

/**
 获取目录绝对路径

 @param baseDirectory 基目录类型
 @param subdirectory 基目录的子目录类型
 @param relativeSubdirectory 相对子目录
 @return 目录绝对路径
 */
FOUNDATION_EXPORT NSString *CTLStoragePathForDirectory(CTLStoragePathBaseDirectory baseDirectory,
                                                       CTLStoragePathSubdirectory subdirectory,
                                                       NSString *relativeSubdirectory);

/**
 获取文件绝对路径

 @param fileFullName 文件全名，包含扩展名
 @param directoryPath 文件所在目录路径
 @return 文件绝对路径
 */
FOUNDATION_EXPORT NSString *CTLStoragePathForFileInDirectory(NSString *fileFullName,
                                                             NSString *directoryPath);

NS_ASSUME_NONNULL_END
