//
//  CTLStoragePathManager.h
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/10/15.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CTLStorageType) {
    CTLStorageTypeDatabases,    // 数据库存储
    CTLStorageTypeArchives,     // 归档存储
    CTLStorageTypeCaches,       // 网络数据缓存
    CTLStorageTypeOthers,       // 其他
};

typedef NS_ENUM(NSUInteger, CTLStoragePathDirectory) {
    CTLStorageDocumentsDirectory,
    CTLStorageLibraryDirectory,
    CTLStorageCachesDirectory,
};

FOUNDATION_EXPORT NSString *CTLStoragePathDirectoryWithType(CTLStoragePathDirectory directory, CTLStorageType storageType);

NS_ASSUME_NONNULL_END
