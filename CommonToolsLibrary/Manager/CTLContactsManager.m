//
//  CTLContactsManager.m
//  huinongwang
//
//  Created by yangyongzheng on 2018/12/8.
//  Copyright © 2018 cnhnb. All rights reserved.
//

#import "CTLContactsManager.h"
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>

@interface CTLContact ()
@property (nonatomic, strong) id recordRef;
@property (nonatomic, strong) id phoneNumberMultiValueRef;
@end

@implementation CTLContact

- (NSString *)firstName {
    if (!_firstName) {
        _firstName = @"";
    }
    return _firstName;
}

- (NSString *)lastName {
    if (!_lastName) {
        _lastName = @"";
    }
    return _lastName;
}

- (NSString *)company {
    if (!_company) {
        _company = @"";
    }
    return _company;
}

+ (instancetype)contactWithCompany:(NSString *)company phoneNumbers:(NSArray<NSString *> *)phoneNumbers {
    CTLContact *contact = [[CTLContact alloc] init];
    contact.company = company;
    contact.phoneNumbers = [NSArray arrayWithArray:phoneNumbers];
    return contact;
}

+ (BOOL)isValidContact:(CTLContact *)contact {
    if (contact && [contact isKindOfClass:[CTLContact class]] &&
        (contact.firstName.length > 0 || contact.lastName.length > 0 || contact.company.length > 0) &&
        contact.phoneNumbers.count > 0) {
        return YES;
    }
    
    return NO;
}

@end

@implementation CTLContactsManager

#pragma mark 通讯录访问授权状态
+ (CTLCMAuthorizationStatus)authorizationStatus {
    CTLCMAuthorizationStatus status = CTLCMAuthorizationStatusNotDetermined;
    if (@available(iOS 9.0, *)) {
        status = (CTLCMAuthorizationStatus)[CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    } else {
        status = (CTLCMAuthorizationStatus)ABAddressBookGetAuthorizationStatus();
    }

    return status;
}

#pragma mark 请求通讯录访问授权
+ (void)requestAccessContactsCompletion:(void(^)(BOOL))completion {
    if ([CTLContactsManager authorizationStatus] == CTLCMAuthorizationStatusNotDetermined) {
        if (@available(iOS 9.0, *)) {
            CNContactStore *contactStore = [[CNContactStore alloc] init];
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (NSThread.isMainThread) {
                    if (completion) {completion(granted);}
                } else {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        if (completion) {completion(granted);}
                    });
                }
            }];
        } else {
            ABAddressBookRef addressBook = ABAddressBookCreate();
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                if (NSThread.isMainThread) {
                    CFRelease(addressBook);
                    if (completion) {completion(granted);}
                } else {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        CFRelease(addressBook);
                        if (completion) {completion(granted);}
                    });
                }
            });
        }
    } else if ([CTLContactsManager authorizationStatus] == CTLCMAuthorizationStatusAuthorized) {
        if (completion) {completion(YES);}
    } else {
        if (completion) {completion(NO);}
    }
}

#pragma mark 更新联系人
+ (void)requestUpdateContact:(CTLContact *)contact completion:(void (^)(BOOL))completion {
    if ([CTLContact isValidContact:contact]) {
        [CTLContactsManager requestAccessContactsCompletion:^(BOOL success) {
            if (success) {
                if (@available(iOS 9.0, *)) {
                    [self contactStoreUpdateContact:contact completion:completion];
                } else {
                    [self addressBookUpdateContact:contact completion:completion];
                }
            } else {
                if (completion) {completion(NO);}
            }
        }];
    } else {
        if (completion) {completion(NO);}
    }
}

#pragma mark - Misc
#pragma mark iOS9.0开始更新通讯录API
+ (void)contactStoreUpdateContact:(CTLContact *)aContact completion:(void (^)(BOOL))completion {
    if (@available(iOS 9.0, *)) {
        BOOL updateResult = YES;
        
        CNContactStore *contactStore = [[CNContactStore alloc] init];
        NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactOrganizationNameKey, CNContactPhoneNumbersKey];
        CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
        
        __block BOOL isNeedToAdd = YES;
        __block CNMutableContact *firstSameNameContact = nil;                   // 记录查找到的第一个同名的联系人，用于更新号码
        __block NSMutableOrderedSet *firstSameNameContactPhoneNumbersSet = nil; // 记录查找到的第一个同名的联系人号码集合，用于更新号码
        BOOL fetchResult = [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            NSString *firstName = contact.givenName ?: @"";
            NSString *lastName = contact.familyName ?: @"";
            NSString *company = contact.organizationName ?: @"";
            if ([aContact.firstName isEqualToString:firstName] &&
                [aContact.lastName isEqualToString:lastName] &&
                [aContact.company isEqualToString:company]) {
                // 已存在同名联系人，继续查询号码
                if (!firstSameNameContact) {firstSameNameContact = [contact mutableCopy];}
                if (isNeedToAdd) {isNeedToAdd = NO;}
                NSMutableOrderedSet *phoneNumbersSet = [NSMutableOrderedSet orderedSet];
                for (CNLabeledValue *labeledValue in contact.phoneNumbers) {
                    CNPhoneNumber *phoneNumber = labeledValue.value;
                    NSString *phoneNumberString = phoneNumber.stringValue;
                    if (phoneNumberString && phoneNumberString.length > 0) {
                        [phoneNumbersSet addObject:phoneNumberString];
                    }
                }
                if (!firstSameNameContactPhoneNumbersSet) {
                    firstSameNameContactPhoneNumbersSet = phoneNumbersSet;
                }
                NSSet *addSet = [NSSet setWithArray:aContact.phoneNumbers];
                if ([addSet isSubsetOfSet:phoneNumbersSet.set]) {
                    // 号码已存在，直接返回YES
                    firstSameNameContact = nil; // 重置
                    firstSameNameContactPhoneNumbersSet = nil; // 重置
                    *stop = YES;
                }
            }
        }];
        
        if (fetchResult) {
            if (isNeedToAdd) {
                // 添加联系人
                CNMutableContact *newContact = [[CNMutableContact alloc] init];
                newContact.givenName = aContact.firstName;
                newContact.familyName = aContact.lastName;
                newContact.organizationName = aContact.company;
                NSMutableArray *phoneNumbers = [NSMutableArray array];
                for (NSString *number in aContact.phoneNumbers) {
                    CNPhoneNumber *phoneNumber = [CNPhoneNumber phoneNumberWithStringValue:number];
                    CNLabeledValue *labeledValue = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMobile value:phoneNumber];
                    if (labeledValue) {
                        [phoneNumbers addObject:labeledValue];
                    }
                }
                newContact.phoneNumbers = [NSArray arrayWithArray:phoneNumbers];
                
                CNSaveRequest *saveRequest = [[CNSaveRequest alloc] init];
                [saveRequest addContact:newContact toContainerWithIdentifier:nil];
                updateResult = [contactStore executeSaveRequest:saveRequest error:nil];
            } else if (firstSameNameContact) {
                // 联系人已存在，添加号码
                NSMutableOrderedSet *addPhoneNumberSet = [NSMutableOrderedSet orderedSetWithArray:aContact.phoneNumbers];
                [addPhoneNumberSet minusOrderedSet:firstSameNameContactPhoneNumbersSet];
                NSMutableArray *phoneNumbers = [NSMutableArray arrayWithArray:firstSameNameContact.phoneNumbers];
                for (NSString *number in addPhoneNumberSet) {
                    CNPhoneNumber *phoneNumber = [CNPhoneNumber phoneNumberWithStringValue:number];
                    CNLabeledValue *labeledValue = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMobile value:phoneNumber];
                    if (labeledValue) {
                        [phoneNumbers addObject:labeledValue];
                    }
                }
                firstSameNameContact.phoneNumbers = [NSArray arrayWithArray:phoneNumbers];
                
                CNSaveRequest *saveRequest = [[CNSaveRequest alloc] init];
                [saveRequest updateContact:firstSameNameContact];
                updateResult = [contactStore executeSaveRequest:saveRequest error:nil];
            }
        } else {
            updateResult = NO;
        }
        
        if (completion) {completion(updateResult);}
    }
}

#pragma mark - iOS9.0之前更新通讯录API
+ (void)addressBookUpdateContact:(CTLContact *)contact completion:(void (^)(BOOL))completion {
    ABAddressBookRef addressBook = ABAddressBookCreate();
    NSArray *allContacts = [self fetchAllContactWithAddressBook:addressBook];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(firstName == %@) AND (lastName == %@) AND (company == %@)", contact.firstName, contact.lastName, contact.company];
    NSArray *sameNameArray = [allContacts filteredArrayUsingPredicate:predicate];
    if (sameNameArray.count > 0) {
        // 已存在同名联系人，继续查询号码
        NSMutableOrderedSet *addPhoneNumberSet = [NSMutableOrderedSet orderedSetWithArray:contact.phoneNumbers];
        BOOL isExist = NO;
        for (CTLContact *p in sameNameArray) {
            NSSet *pSet = [NSSet setWithArray:p.phoneNumbers];
            if ([addPhoneNumberSet isSubsetOfSet:pSet]) {
                isExist = YES;
                break;
            }
        }
        
        if (isExist) {
            // 已存在联系人及其号码，直接返回YES
            if (addressBook) {CFRelease(addressBook);}
            if (completion) {completion(YES);}
        } else {
            // 已存在联系人，但其号码不存在，添加号码
            CTLContact *firstSameNameContact = sameNameArray.firstObject;
            [addPhoneNumberSet minusOrderedSet:[NSOrderedSet orderedSetWithArray:firstSameNameContact.phoneNumbers]];// 取差集
            bool removeResult = ABAddressBookRemoveRecord(addressBook,
                                                          (__bridge ABRecordRef)firstSameNameContact.recordRef,
                                                          NULL);
            if (removeResult) {
                // 删除成功后再重新插入一条联系人数据
                firstSameNameContact.phoneNumbers = addPhoneNumberSet.array;
                BOOL addResult = [self addressBook:addressBook addContact:firstSameNameContact];
                if (addressBook) {CFRelease(addressBook);}
                if (completion) {completion(addResult);}
            } else {
                if (addressBook) {CFRelease(addressBook);}
                if (completion) {completion(NO);}
            }
        }
    } else {
        // 不存在同名联系人，添加联系人及其号码
        BOOL result = [self addressBook:addressBook addContact:contact];
        if (addressBook) {CFRelease(addressBook);}
        if (completion) {completion(result);}
    }
}

#pragma mark 获取通讯录所有联系人
+ (NSArray<CTLContact *> *)fetchAllContactWithAddressBook:(ABAddressBookRef)addressBook {
    if (addressBook == NULL) {
        return nil;
    }
    // 获取通讯录所有联系人
    NSMutableArray *allContacts = [NSMutableArray array];
    CFArrayRef arrayRef = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex totalCount = ABAddressBookGetPersonCount(addressBook);
    for (CFIndex i = 0; i < totalCount; i++) {
        // 获取联系人以及其详细信息，如：姓名、电话、住址等信息
        ABRecordRef people = CFArrayGetValueAtIndex(arrayRef, i);
        if (people) {
            CTLContact *contact = [[CTLContact alloc] init];
            contact.recordRef = (__bridge id)people;
            // CF转化为OC对象时，负责释放CF对象
            contact.firstName = CFBridgingRelease(ABRecordCopyValue(people, kABPersonFirstNameProperty));
            contact.lastName = CFBridgingRelease(ABRecordCopyValue(people, kABPersonLastNameProperty));
            contact.company = CFBridgingRelease(ABRecordCopyValue(people, kABPersonOrganizationProperty));
            
            ABMultiValueRef phoneNumbersRef = ABRecordCopyValue(people, kABPersonPhoneProperty);
            contact.phoneNumbers = CFBridgingRelease(ABMultiValueCopyArrayOfAllValues(phoneNumbersRef));
            contact.phoneNumberMultiValueRef = CFBridgingRelease(phoneNumbersRef);
            
            [allContacts addObject:contact];
        }
    }
    // 释放CF对象
    if (arrayRef) {CFRelease(arrayRef);}
    
    return [NSArray arrayWithArray:allContacts];
}

#pragma mark 添加联系人到通讯录
+ (BOOL)addressBook:(ABAddressBookRef)addressBook addContact:(CTLContact *)addContact {
    ABRecordRef newRecord = ABPersonCreate();
    ABMutableMultiValueRef multiValueRef = NULL;
    if (addContact.phoneNumberMultiValueRef) {
        multiValueRef = ABMultiValueCreateMutableCopy((__bridge ABMultiValueRef)addContact.phoneNumberMultiValueRef);
    } else {
        multiValueRef = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    }
    
    // 为新联系人记录添加属性值
    bool aResult = true, bResult = true, cResult = true;
    if (addContact.firstName.length > 0) {
        aResult = ABRecordSetValue(newRecord,
                                   kABPersonFirstNameProperty,
                                   (__bridge CFTypeRef)addContact.firstName,
                                   NULL);
    }
    if (addContact.lastName.length > 0) {
        bResult = ABRecordSetValue(newRecord,
                                   kABPersonLastNameProperty,
                                   (__bridge CFTypeRef)addContact.lastName,
                                   NULL);
    }
    if (addContact.company.length > 0) {
        cResult = ABRecordSetValue(newRecord,
                                   kABPersonOrganizationProperty,
                                   (__bridge CFTypeRef)addContact.company,
                                   NULL);
    }
    
    // 添加电话号码
    bool dResult = true;
    for (NSString *phoneNumber in addContact.phoneNumbers) {
        dResult = ABMultiValueAddValueAndLabel(multiValueRef,
                                               (__bridge CFTypeRef)phoneNumber,
                                               kABPersonPhoneMobileLabel,
                                               NULL);
        if (!dResult) {
            break;
        }
    }
    if (dResult) {
        dResult = ABRecordSetValue(newRecord,
                                   kABPersonPhoneProperty,
                                   multiValueRef,
                                   NULL);
    }
    
    BOOL success = NO;
    if (aResult && bResult && cResult && dResult) {
        // 添加记录到通讯录操作对象
        bool addSuccess = ABAddressBookAddRecord(addressBook, newRecord, NULL);
        // 保存通讯录操作对象
        bool saveSuccess = ABAddressBookSave(addressBook, NULL);
        success = addSuccess && saveSuccess;
    }
    
    if (multiValueRef) {CFRelease(multiValueRef);}
    if (newRecord) {CFRelease(newRecord);}
    
    return success;
}

@end
