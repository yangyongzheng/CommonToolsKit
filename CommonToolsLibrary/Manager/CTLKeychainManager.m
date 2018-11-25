//
//  CTLKeychainManager.m
//  KeychainTest
//
//  Created by 杨永正 on 2018/11/24.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#import "CTLKeychainManager.h"

@implementation CTLKeychainQuery    @end

const NSInteger CTLKeychainManagerErrorBadParameters = 700000;

static NSString * const CTLKeychainManagerErrorDomainBadParameters = @"One or more parameters passed to a function were not valid.";
// Security Error Codes Domain
static NSString * const CTLKeychainManagerErrorDomainSecurity = @"See \"Security Error Codes\" (Security/SecBase.h)";

@implementation CTLKeychainManager

+ (NSData *)dataWithQuery:(CTLKeychainQuery *)query error:(NSError * _Nullable __autoreleasing *)error {
    OSStatus status = errSecSuccess;
    NSErrorDomain errorDomain = nil;
    
    if (query && [query isKindOfClass:[CTLKeychainQuery class]] &&
        query.attrAccount.length > 0 && query.attrService.length > 0) {
        NSMutableDictionary *queryDictionary = [self queryDictionaryWithQuery:query];
        // 返回第一个匹配item
        [queryDictionary setObject:__CTLKMNSStringBridge(kSecMatchLimitOne)
                            forKey:__CTLKMNSStringBridge(kSecMatchLimit)];
        [queryDictionary setObject:__CTLKMNSNumberBridge(kCFBooleanTrue)
                            forKey:__CTLKMNSStringBridge(kSecReturnData)];
        [queryDictionary setObject:__CTLKMNSNumberBridge(kCFBooleanTrue)
                            forKey:__CTLKMNSStringBridge(kSecReturnAttributes)];
        
        CFTypeRef resultDictionaryRef = NULL;
        status = SecItemCopyMatching(((__bridge CFDictionaryRef)queryDictionary), &resultDictionaryRef);
        if (status == errSecSuccess) {
            NSDictionary *resultDictionary = ((__bridge_transfer NSDictionary *)resultDictionaryRef);
            return [resultDictionary objectForKey:__CTLKMNSStringBridge(kSecValueData)];
        } else {
            if (resultDictionaryRef) {
                CFRelease(resultDictionaryRef);
            }
            // 忽略 未找到item 错误
            if (status == errSecItemNotFound) {
                status = errSecSuccess; // 重置
            }
        }
    } else {
        status = CTLKeychainManagerErrorBadParameters;
        errorDomain = CTLKeychainManagerErrorDomainBadParameters;
    }
    
    // 错误回调赋值
    if (status != errSecSuccess && error) {
        *error = [NSError errorWithDomain:errorDomain?:CTLKeychainManagerErrorDomainSecurity
                                     code:status
                                 userInfo:@{NSLocalizedDescriptionKey:errorDomain}];
    }
    
    return nil;
}

+ (BOOL)updateItemData:(NSData *)itemData withQuery:(CTLKeychainQuery *)query error:(NSError * _Nullable __autoreleasing *)error {
    OSStatus status = errSecSuccess;
    NSErrorDomain errorDomain = nil;
    
    if (query && [query isKindOfClass:[CTLKeychainQuery class]] &&
        query.attrAccount.length > 0 && query.attrService.length > 0 &&
        itemData && [itemData isKindOfClass:[NSData class]] && itemData.length > 0) {
        
        NSMutableDictionary *queryDictionary = [self queryDictionaryWithQuery:query];
        status = SecItemCopyMatching(((__bridge CFDictionaryRef)queryDictionary), NULL);
        if (status == errSecSuccess) {
            // 已存在item，更新
            NSMutableDictionary *attributesToUpdate = [NSMutableDictionary dictionary];
            [attributesToUpdate setObject:itemData
                                   forKey:__CTLKMNSStringBridge(kSecValueData)];
            status = SecItemUpdate(((__bridge CFDictionaryRef)queryDictionary),
                                   ((__bridge CFDictionaryRef)attributesToUpdate));
        } else if (status == errSecItemNotFound) {
            // 未存在item，直接添加
            NSMutableDictionary *addAttributes = [NSMutableDictionary dictionaryWithDictionary:queryDictionary];
            [addAttributes setObject:itemData
                              forKey:__CTLKMNSStringBridge(kSecValueData)];
            status = SecItemAdd(((__bridge CFDictionaryRef)addAttributes), NULL);
        }
    } else {
        status = CTLKeychainManagerErrorBadParameters;
        errorDomain = CTLKeychainManagerErrorDomainBadParameters;
    }
    
    // 错误回调赋值
    if (status != errSecSuccess && error) {
        *error = [NSError errorWithDomain:errorDomain?:CTLKeychainManagerErrorDomainSecurity
                                     code:status
                                 userInfo:@{NSLocalizedDescriptionKey:errorDomain}];
    }
    
    return status == errSecSuccess;
}

+ (BOOL)deleteItemWithQuery:(CTLKeychainQuery *)query error:(NSError * _Nullable __autoreleasing *)error {
    OSStatus status = errSecSuccess;
    NSErrorDomain errorDomain = nil;
    
    if (query && [query isKindOfClass:[CTLKeychainQuery class]] &&
        query.attrAccount.length > 0 && query.attrService.length > 0) {
        NSMutableDictionary *queryDictionary = [self queryDictionaryWithQuery:query];
        status = SecItemDelete((__bridge CFDictionaryRef)queryDictionary);
        // 忽略 未找到item 错误
        if (status == errSecItemNotFound) {
            status = errSecSuccess; // 重置
        }
    } else {
        status = CTLKeychainManagerErrorBadParameters;
        errorDomain = CTLKeychainManagerErrorDomainBadParameters;
    }
    
    // 错误回调赋值
    if (status != errSecSuccess && error) {
        *error = [NSError errorWithDomain:errorDomain?:CTLKeychainManagerErrorDomainSecurity
                                     code:status
                                 userInfo:@{NSLocalizedDescriptionKey:errorDomain}];
    }
    
    return status == errSecSuccess;
}

#pragma mark - Private Method
static NSString * __CTLKMNSStringBridge(CFStringRef ref) {
    return (__bridge NSString *)ref;
}

static NSNumber * __CTLKMNSNumberBridge(CFBooleanRef ref) {
    return (__bridge NSNumber *)ref;
}

+ (NSMutableDictionary *)queryDictionaryWithQuery:(CTLKeychainQuery *)queryModel {
    NSMutableDictionary *queryDictionary = [NSMutableDictionary dictionary];
    
    [queryDictionary setObject:__CTLKMNSStringBridge(kSecClassGenericPassword)
                        forKey:__CTLKMNSStringBridge(kSecClass)];
    [queryDictionary setObject:__CTLKMNSStringBridge(kSecAttrAccessibleAfterFirstUnlock)
                        forKey:__CTLKMNSStringBridge(kSecAttrAccessible)];
#if !TARGET_IPHONE_SIMULATOR
    if (queryModel.attrAccessGroup.length > 0) {
        [queryDictionary setObject:queryModel.attrAccessGroup
                            forKey:__CTLKMNSStringBridge(kSecAttrAccessGroup)];
    }
#endif
    if (queryModel.attrAccount.length > 0) {
        [queryDictionary setObject:queryModel.attrAccount
                            forKey:__CTLKMNSStringBridge(kSecAttrAccount)];
    }
    if (queryModel.attrService.length > 0) {
        [queryDictionary setObject:queryModel.attrService
                            forKey:__CTLKMNSStringBridge(kSecAttrService)];
    }
    
    return queryDictionary;
}

@end
