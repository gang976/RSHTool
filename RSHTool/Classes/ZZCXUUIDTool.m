//
//  ZZCXUUIDTool.m
//  ZZCXDriver
//
//  Created by 李志强 on 5/7/19.
//  Copyright © 2019 qnchuxing. All rights reserved.
//
#import "ZZCXUUIDTool.h"

#define ZZCX_DEVICE_UUID      [[UIDevice currentDevice].identifierForVendor UUIDString]

NSString * const KEY_UDID_INSTEAD = @"com.myapp.udid.test";

@implementation ZZCXUUIDTool

+ (NSString *)getPhoneIdentifier
{
    NSString *getUDIDInKeychain = (NSString *)[ZZCXUUIDTool load:KEY_UDID_INSTEAD];
    //    NSLog(@"从keychain中获取到的 UDID_INSTEAD %@",getUDIDInKeychain);
    if (!getUDIDInKeychain ||[getUDIDInKeychain isEqualToString:@""]||[getUDIDInKeychain isKindOfClass:[NSNull class]]) {
//        CFUUIDRef puuid = CFUUIDCreate( nil );
//        CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
//        NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
//        CFRelease(puuid);
//        CFRelease(uuidString);
        //        NSLog(@"\n \n \n _____重新存储 UUID _____\n \n \n  %@",result);
        [ZZCXUUIDTool save:KEY_UDID_INSTEAD data:ZZCX_DEVICE_UUID];
        getUDIDInKeychain = (NSString *)[ZZCXUUIDTool load:KEY_UDID_INSTEAD];
    }
    //    NSLog(@"最终 ———— UDID_INSTEAD %@",getUDIDInKeychain);
    return getUDIDInKeychain;
}

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

+ (void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

+ (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (void)deleteIdentifier:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

@end
