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
#import "CTLCommonMacros.h"

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
CTL_STATIC_INLINE NSComparisonResult CTLCompareVersion(NSString *v1, NSString *v2) {
    // 以小数点结尾的补'0'再比较
    if ([v1 hasSuffix:@"."]) {
        v1 = [v1 stringByAppendingString:@"0"];
    }
    if ([v2 hasSuffix:@"."]) {
        v2 = [v2 stringByAppendingString:@"0"];
    }
    return [v1 compare:v2 options:NSNumericSearch];
}

CTL_EXTERN BOOL CTLSystemVersionEqualTo(NSString *version);
CTL_EXTERN BOOL CTLSystemVersionGreaterThan(NSString *version);
CTL_EXTERN BOOL CTLSystemVersionGreaterThanOrEqualTo(NSString *version);
CTL_EXTERN BOOL CTLSystemVersionLessThan(NSString *version);
CTL_EXTERN BOOL CTLSystemVersionLessThanOrEqualTo(NSString *version);


#pragma mark - 基本数据类型判空函数
CTL_STATIC_INLINE BOOL CTLAssertStringNotEmpty(id str) {
    return str && [str isKindOfClass:[NSString class]] && ((NSString *)str).length > 0;
}

CTL_STATIC_INLINE BOOL CTLAssertStringIsEmpty(id str) {
    return !CTLAssertStringNotEmpty(str);
}

CTL_STATIC_INLINE BOOL CTLAssertArrayNotEmpty(id array) {
    return array && [array isKindOfClass:[NSArray class]] && ((NSArray *)array).count > 0;
}

CTL_STATIC_INLINE BOOL CTLAssertArrayIsEmpty(id array) {
    return !CTLAssertArrayNotEmpty(array);
}

CTL_STATIC_INLINE BOOL CTLAssertMutableArrayNotEmpty(id mutableArray) {
    return mutableArray && [mutableArray isKindOfClass:[NSMutableArray class]] && ((NSMutableArray *)mutableArray).count > 0;
}

CTL_STATIC_INLINE BOOL CTLAssertMutableArrayIsEmpty(id mutableArray) {
    return !CTLAssertMutableArrayNotEmpty(mutableArray);
}

CTL_STATIC_INLINE BOOL CTLAssertDictionaryNotEmpty(id dictionary) {
    return dictionary && [dictionary isKindOfClass:[NSDictionary class]] && ((NSDictionary *)dictionary).count > 0;
}

CTL_STATIC_INLINE BOOL CTLAssertDictionaryIsEmpty(id dictionary) {
    return !CTLAssertDictionaryNotEmpty(dictionary);
}

CTL_STATIC_INLINE BOOL CTLAssertMutableDictionaryNotEmpty(id mutableDictionary) {
    return mutableDictionary && [mutableDictionary isKindOfClass:[NSMutableDictionary class]] && ((NSMutableDictionary *)mutableDictionary).count > 0;
}

CTL_STATIC_INLINE BOOL CTLAssertMutableDictionaryIsEmpty(id mutableDictionary) {
    return !CTLAssertMutableDictionaryNotEmpty(mutableDictionary);
}


#pragma mark - 安全主线程回调
// 1.当前非主线程时 同步回调主线程
CTL_STATIC_INLINE void CTLSafeSyncMainQueueHandler(void(^handler)(void)) {
    if (handler) {
        if ([NSThread isMainThread]) {
            handler();
        } else {
            dispatch_sync(dispatch_get_main_queue(), handler);
        }
    }
}

// 2.当前非主线程时 异步回调主线程
CTL_STATIC_INLINE void CTLSafeAsyncMainQueueHandler(void(^handler)(void)) {
    if (handler) {
        if ([NSThread isMainThread]) {
            handler();
        } else {
            dispatch_async(dispatch_get_main_queue(), handler);
        }
    }
}


#pragma mark - 从Storyboard实例化UIViewController
CTL_STATIC_INLINE UIViewController *CTLLoadControllerInMainStoryboard(NSString *identifier) {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle];
    return [sb instantiateViewControllerWithIdentifier:identifier];
}

CTL_STATIC_INLINE UIViewController *CTLLoadControllerInStoryboard(NSString *storyboardName, NSString *identifier) {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:storyboardName bundle:NSBundle.mainBundle];
    return [sb instantiateViewControllerWithIdentifier:identifier];
}


#pragma mark - 从Xib实例化UIView
CTL_STATIC_INLINE UIView *CTLLoadViewInNib(NSString *nibName) {
    if (nibName && [nibName isKindOfClass:[NSString class]] && nibName.length > 0) {
        NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
        for (UIView *view in viewArray) {
            if (view && [view isKindOfClass:[UIView class]]) {
                return view;
            }
        }
    }
    
    return nil;
}

CTL_STATIC_INLINE UIView *CTLLoadViewInNibAtIndex(NSString *nibName, NSInteger index) {
    if (nibName && [nibName isKindOfClass:[NSString class]] && nibName.length > 0) {
        NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
        if (index < viewArray.count) {
            UIView *obj = [viewArray objectAtIndex:index];
            if ([obj isKindOfClass:[UIView class]]) {
                return obj;
            }
        }
    }
    
    return nil;
}


#pragma mark - 编译时间戳
/**
 编译时间戳，单位秒
 */
CTL_STATIC_INLINE NSTimeInterval __CTLCompileTimestamp(void) {
    NSString *timeStr = [NSString stringWithFormat:@"%s %s", __DATE__, __TIME__];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd yyyy HH:mm:ss"];
    [formatter setLocale:locale];
    return [[formatter dateFromString:timeStr] timeIntervalSince1970];
}

#endif /* CTLCommonFunction_h */
