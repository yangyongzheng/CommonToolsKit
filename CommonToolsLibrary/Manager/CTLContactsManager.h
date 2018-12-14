//
//  CTLContactsManager.h
//  huinongwang
//
//  Created by yangyongzheng on 2018/12/8.
//  Copyright © 2018 cnhnb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CTLContact : NSObject
// 三者必须有一个非空
@property (nullable, nonatomic, copy) NSString *firstName;
@property (nullable, nonatomic, copy) NSString *lastName;
@property (nullable, nonatomic, copy) NSString *company;
// 电话号码不能为空
@property (nonatomic, copy) NSArray<NSString *> *phoneNumbers;

// 生成惠农网客户对象
+ (instancetype)contactWithCompany:(NSString *)company phoneNumbers:(NSArray<NSString *> *)phoneNumbers;

// 是否是一个有效的联系人
+ (BOOL)isValidContact:(CTLContact *)contact;
@end

typedef NS_ENUM(NSInteger, CTLCMAuthorizationStatus) {
    CTLCMAuthorizationStatusNotDetermined = 0,
    CTLCMAuthorizationStatusRestricted,
    CTLCMAuthorizationStatusDenied,
    CTLCMAuthorizationStatusAuthorized
};

@interface CTLContactsManager : NSObject
@property (class, nonatomic, readonly) CTLCMAuthorizationStatus authorizationStatus;

/**
 请求授权访问通讯录

 @param completion 访问授权结果回调（主线程回调）
 */
+ (void)requestAccessContactsCompletion:(void(^)(BOOL success))completion;

/**
 请求更新联系人

 @param contact 待更新联系人
 @param completion 更新结果回调（主线程回调）
 */
+ (void)requestUpdateContact:(CTLContact *)contact completion:(void(^)(BOOL success))completion;


@end

NS_ASSUME_NONNULL_END
