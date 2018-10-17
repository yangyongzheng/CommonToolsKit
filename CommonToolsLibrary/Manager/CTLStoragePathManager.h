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
};

typedef NSString * CTLStorageDirectory;

@interface CTLStoragePathManager : NSObject

@property (class, nonatomic, readonly) CTLStorageDirectory storageDocumentsDirectory;   // ~/Documents
@property (class, nonatomic, readonly) CTLStorageDirectory storageLibraryDirectory;     // ~/Library
@property (class, nonatomic, readonly) CTLStorageDirectory storageCacheDirectory;       // ~/Library/Caches
@property (class, nonatomic, readonly) CTLStorageDirectory storageTempDirectory;        // ~/tmp/

+ (NSString *)directoryWithBaseDirectory:(CTLStorageDirectory)baseDirectory relativeSubdirectory:(NSString *)relativeSubdirectory;
+ (NSString *)relativeSubdirectoryWithStorageType:(CTLStorageType)storageType;

@end

NS_ASSUME_NONNULL_END
