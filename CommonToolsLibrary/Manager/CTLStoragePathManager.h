//
//  CTLStoragePathManager.h
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/10/15.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CTLStoragePathManager : NSObject

+ (NSString *)storageHomeDirectory;
+ (NSString *)storageDocumentsDirectory;
+ (NSString *)storageLibraryDirectory;
+ (NSString *)storageCacheDirectory;
+ (NSString *)storageTempDirectory;

@end

NS_ASSUME_NONNULL_END
