//
//  CTLCommonFunction.h
//  CommonToolsKit
//
//  Created by yangyongzheng on 2018/11/1.
//  Copyright © 2018年 yangyongzheng. All rights reserved.
//

#ifndef CTLCommonFunction_h
#define CTLCommonFunction_h

#import <UIKit/UIKit.h>

#pragma mark - 系统版本判断
/**
 判断两个版本号大小, 如：@"3" > @"2.9.6", @"2.9" < @"2.9.0", @"2.8.9" < @"2.9.0", @"2.8.9" == @"2.8.9"
 NSOrderedAscending : v1 < v2
 NSOrderedSame : v1 == v2
 NSOrderedDescending : v1 > v2
 
 @param v1 版本号
 @param v2 版本号
 @return 比较结果
 */
CTL_STATIC_INLINE NSComparisonResult CFLCompareVersion(NSString *v1, NSString *v2) {
    // 以小数点结尾的补'0'再比较
    if ([v1 hasSuffix:@"."]) {
        v1 = [v1 stringByAppendingString:@"0"];
    }
    if ([v2 hasSuffix:@"."]) {
        v2 = [v2 stringByAppendingString:@"0"];
    }
    return [v1 compare:v2 options:NSNumericSearch];
}

CTL_STATIC_INLINE BOOL CFLSystemVersionEqualTo(NSString *version) {
    return CFLCompareVersion(UIDevice.currentDevice.systemVersion, version) == NSOrderedSame;
}

CTL_STATIC_INLINE BOOL CFLSystemVersionGreaterThan(NSString *version) {
    return CFLCompareVersion(UIDevice.currentDevice.systemVersion, version) == NSOrderedDescending;
}

CTL_STATIC_INLINE BOOL CFLSystemVersionGreaterThanOrEqualTo(NSString *version) {
    return CFLCompareVersion(UIDevice.currentDevice.systemVersion, version) != NSOrderedAscending;
}

CTL_STATIC_INLINE BOOL CFLSystemVersionLessThan(NSString *version) {
    return CFLCompareVersion(UIDevice.currentDevice.systemVersion, version) == NSOrderedAscending;
}

CTL_STATIC_INLINE BOOL CFLSystemVersionLessThanOrEqualTo(NSString *version) {
    return CFLCompareVersion(UIDevice.currentDevice.systemVersion, version) != NSOrderedDescending;
}


#pragma mark - 基本数据类型判空函数
CTL_STATIC_INLINE BOOL CFLAssertStringNotEmpty(id str) {
    return str && [str isKindOfClass:[NSString class]] && ((NSString *)str).length > 0;
}

CTL_STATIC_INLINE BOOL CFLAssertStringIsEmpty(id str) {
    return !CFLAssertStringNotEmpty(str);
}

CTL_STATIC_INLINE BOOL CFLAssertArrayNotEmpty(id array) {
    return array && [array isKindOfClass:[NSArray class]] && ((NSArray *)array).count > 0;
}

CTL_STATIC_INLINE BOOL CFLAssertArrayIsEmpty(id array) {
    return !CFLAssertArrayNotEmpty(array);
}

CTL_STATIC_INLINE BOOL CFLAssertMutableArrayNotEmpty(id mutableArray) {
    return mutableArray && [mutableArray isKindOfClass:[NSMutableArray class]] && ((NSMutableArray *)mutableArray).count > 0;
}

CTL_STATIC_INLINE BOOL CFLAssertMutableArrayIsEmpty(id mutableArray) {
    return !CFLAssertMutableArrayNotEmpty(mutableArray);
}

CTL_STATIC_INLINE BOOL CFLAssertDictionaryNotEmpty(id dictionary) {
    return dictionary && [dictionary isKindOfClass:[NSDictionary class]] && ((NSDictionary *)dictionary).count > 0;
}

CTL_STATIC_INLINE BOOL CFLAssertDictionaryIsEmpty(id dictionary) {
    return !CFLAssertDictionaryNotEmpty(dictionary);
}

CTL_STATIC_INLINE BOOL CFLAssertMutableDictionaryNotEmpty(id mutableDictionary) {
    return mutableDictionary && [mutableDictionary isKindOfClass:[NSMutableDictionary class]] && ((NSMutableDictionary *)mutableDictionary).count > 0;
}

CTL_STATIC_INLINE BOOL CFLAssertMutableDictionaryIsEmpty(id mutableDictionary) {
    return !CFLAssertMutableDictionaryNotEmpty(mutableDictionary);
}


#pragma mark - 安全主线程回调
// 1.同步回调主线程
CTL_STATIC_INLINE void CFLSafeSyncMainQueueHandler(void(^handler)(void)) {
    if (handler) {
        if ([NSThread isMainThread]) {
            handler();
        } else {
            dispatch_sync(dispatch_get_main_queue(), handler);
        }
    }
}

// 2.异步回调主线程
CTL_STATIC_INLINE void CFLSafeAsyncMainQueueHandler(void(^handler)(void)) {
    if (handler) {
        if ([NSThread isMainThread]) {
            handler();
        } else {
            dispatch_async(dispatch_get_main_queue(), handler);
        }
    }
}

#endif /* CTLCommonFunction_h */
