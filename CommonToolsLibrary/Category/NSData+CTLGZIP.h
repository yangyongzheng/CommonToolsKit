//
//  NSData+CTLGZIP.h
//  CommonToolsKit
//
//  Created by 杨永正 on 2018/11/4.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (CTLGZIP)

/**
 Z_NO_COMPRESSION         0
 Z_BEST_SPEED             1
 Z_BEST_COMPRESSION       9
 Z_DEFAULT_COMPRESSION  (-1)
 
 @param level 压缩率
 @return gzip压缩后对象
 */
- (nullable NSData *)ctl_gzippedDataWithCompressionLevel:(int)level;

/**
 使用默认压缩率(Z_DEFAULT_COMPRESSION)
 
 @return gzip压缩后对象
 */
- (nullable NSData *)ctl_gzippedData;

/**
 gzip解压缩
 
 @return 解压缩后对象
 */
- (nullable NSData *)ctl_gunzippedData;

/** 是否已gzip压缩 */
- (BOOL)ctl_isGzippedData;

@end

NS_ASSUME_NONNULL_END
