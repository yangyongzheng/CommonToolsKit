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
    CTLStorageDatabasesSubdirectory,    // 数据库存储
    CTLStorageArchivesSubdirectory,     // 归档存储
    CTLStorageCachesSubdirectory,       // 网络数据缓存
    CTLStorageOthersSubdirectory,       // 其他
};

typedef NS_ENUM(NSUInteger, CTLStoragePathBaseDirectory) {
    CTLStorageDocumentsBaseDirectory,
    CTLStorageLibraryBaseDirectory,
    CTLStorageCachesBaseDirectory,
    CTLStorageTempBaseDirectory,
};


/**
 获取目录绝对路径

 @param baseDirectory 基目录
 @param subdirectory 子目录类型
 @return 目录绝对路径
 */
FOUNDATION_EXPORT NSString *CTLStoragePathForDirectory(CTLStoragePathBaseDirectory baseDirectory, CTLStoragePathSubdirectory subdirectory);

/**
 获取文件绝对路径

 @param fileFullName 文件全名，包含扩展名
 @param directoryPath 文件所在目录路径
 @return 文件绝对路径
 */
FOUNDATION_EXPORT NSString *CTLStoragePathForFileInDirectory(NSString *fileFullName, NSString *directoryPath);

NS_ASSUME_NONNULL_END
