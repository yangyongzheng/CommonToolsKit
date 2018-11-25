//
//  CTLKeychainManager.h
//  KeychainTest
//
//  Created by 杨永正 on 2018/11/24.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** 参数错误code */
FOUNDATION_EXTERN const NSInteger CTLKeychainManagerErrorBadParameters;

@interface CTLKeychainQuery : NSObject
@property (nullable, nonatomic, copy) NSString *attrAccessGroup;    // the access group an item is in
@property (nonatomic, copy) NSString *attrAccount;                  // item's account name
@property (nonatomic, copy) NSString *attrService;                  // item's service
@end


@interface CTLKeychainManager : NSObject

/**
 查询item's data

 @param query 查询条件model, 当传入nil时使用默认值[CTLKeychainQuery defaultQuery]
 @param error 查询结果错误信息
 @return 查询结果
 */
+ (nullable NSData *)dataWithQuery:(CTLKeychainQuery *)query
                             error:(NSError **)error;

/**
 更新item

 @param query 更新条件model, 当传入nil时使用默认值[CTLKeychainQuery defaultQuery]
 @param error 更新结果错误信息
 @return 返回更新结果
 */
+ (BOOL)updateItemData:(NSData *)itemData
             withQuery:(CTLKeychainQuery *)query
                 error:(NSError **)error;

/**
 删除item
 
 @param query 删除条件model, 当传入nil时使用默认值[CTLKeychainQuery defaultQuery]
 @param error 删除结果错误信息
 @return 返回删除结果
 */
+ (BOOL)deleteItemWithQuery:(CTLKeychainQuery *)query
                      error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
