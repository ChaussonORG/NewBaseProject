//
//  CHToolKit.m
//  Project
//
//  Created by Chausson on 16/6/30.
//  Copyright © 2016年 Chausson. All rights reserved.
//

#import "CHToolKit.h"
#import <objc/runtime.h>
#import <CommonCrypto/CommonDigest.h>
#import <Security/Security.h>
#import <UIKit/UIKit.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

static const char kKeychainUDIDItemIdentifier[]  = "UUID";
static const char kKeyChainUDIDAccessGroup[] = "Chausson.NewProjectExample";
static bool loadLaunchFlag;
@implementation CHToolKit
+ (void)load{
   loadLaunchFlag = [CHToolKit launchFlag];
}
+ (BOOL)isFirstLaunch{
    return loadLaunchFlag;
}

+ (NSString*)UDID
{
    NSString *udid = [CHToolKit getUDIDFromKeyChain];
    if (!udid) {
        
        NSString *sysVersion = [UIDevice currentDevice].systemVersion;
        CGFloat version = [sysVersion floatValue];
        
        if (version >= 7.0) {
            udid = [CHToolKit _UDID_iOS7];
        }
        else if (version >= 2.0) {
            udid = [CHToolKit _UDID_iOS6];
        }
        
        [CHToolKit settUDIDToKeyChain:udid];
    }
    
    return udid;
}
+ (NSString *)md5FromString:(NSString *)string {
    if(string == nil || [string length] == 0)
        return nil;
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}
+ (BOOL)hasUDIDInKeyChain
{
    NSString *udid = [CHToolKit getUDIDFromKeyChain];
    if (udid) {
        return YES;
    }
    return NO;
}
+ (NSString*)_UDID_iOS6
{
    return [CHToolKit getMacAddress];
}

/*
 * iOS 7.0
 * Starting from iOS 7, the system always returns the value 02:00:00:00:00:00
 * when you ask for the MAC address on any device.
 * use identifierForVendor + keyChain
 * make sure UDID consistency atfer app delete and reinstall
 */
+ (NSString*)_UDID_iOS7
{
    return [[UIDevice currentDevice].identifierForVendor UUIDString];
}


#pragma mark -
#pragma mark Helper Method for Get Mac Address

// from http://stackoverflow.com/questions/677530/how-can-i-programmatically-get-the-mac-address-of-an-iphone
+ (NSString *)getMacAddress
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = nil;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    
    // Befor going any further...
    if (errorFlag != NULL)
    {
        NSLog(@"Error: %@", errorFlag);
        if (msgBuffer) {
            free(msgBuffer);
        }
        
        return errorFlag;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
    NSLog(@"Mac Address: %@", macAddressString);
    
    // Release the buffer memory
    free(msgBuffer);
    
    return macAddressString;
}

#pragma mark -
#pragma mark Helper Method for make identityForVendor consistency

+ (NSString*)getUDIDFromKeyChain
{
    NSMutableDictionary *dictForQuery = [[NSMutableDictionary alloc] init];
    [dictForQuery setValue:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    // set Attr Description for query
    [dictForQuery setValue:[NSString stringWithUTF8String:kKeychainUDIDItemIdentifier]
                    forKey:(__bridge NSString *)(kSecAttrDescription)];
    
    // set Attr Identity for query
    NSData *keychainItemID = [NSData dataWithBytes:kKeychainUDIDItemIdentifier
                                            length:strlen(kKeychainUDIDItemIdentifier)];
    [dictForQuery setObject:keychainItemID forKey:(__bridge id)kSecAttrGeneric];
    
    // The keychain access group attribute determines if this item can be shared
    // amongst multiple apps whose code signing entitlements contain the same keychain access group.
    NSString *accessGroup = [NSString stringWithUTF8String:kKeyChainUDIDAccessGroup];
    if (accessGroup != nil)
    {
#if TARGET_IPHONE_SIMULATOR
        // Ignore the access group if running on the iPhone simulator.
        //
        // Apps that are built for the simulator aren't signed, so there's no keychain access group
        // for the simulator to check. This means that all apps can see all keychain items when run
        // on the simulator.
        //
        // If a SecItem contains an access group attribute, SecItemAdd and SecItemUpdate on the
        // simulator will return -25243 (errSecNoAccessForItem).
#else
        [dictForQuery setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
#endif
    }
    
    [dictForQuery setValue:(id)kCFBooleanTrue forKey:(__bridge id)kSecMatchCaseInsensitive];
    [dictForQuery setValue:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [dictForQuery setValue:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    
    OSStatus queryErr   = noErr;
    NSData   *udidValue = nil;
    NSString *udid      = nil;
    queryErr = SecItemCopyMatching((__bridge CFDictionaryRef)dictForQuery, (void *)&udidValue);
    
    NSMutableDictionary *dict = nil;
    [dictForQuery setValue:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
    queryErr = SecItemCopyMatching((__bridge CFDictionaryRef)dictForQuery, (void *)&dict);
    
    if (queryErr == errSecItemNotFound) {
        // NSLog(@"KeyChain Item: %@ not found!!!", [NSString stringWithUTF8String:kKeychainUDIDItemIdentifier]);
    }
    else if (queryErr != errSecSuccess) {
        //  NSLog(@"KeyChain Item query Error!!! Error code:%d", (int)queryErr);
    }
    if (queryErr == errSecSuccess) {
        //  NSLog(@"KeyChain Item: %@", udidValue);
        
        if (udidValue) {
            udid = [NSString stringWithUTF8String:udidValue.bytes];
        }
    }
    
    //[dictForQuery release];
    return udid;
}

+ (BOOL)settUDIDToKeyChain:(NSString*)udid
{
    NSMutableDictionary *dictForAdd = [[NSMutableDictionary alloc] init];
    
    [dictForAdd setValue:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [dictForAdd setValue:[NSString stringWithUTF8String:kKeychainUDIDItemIdentifier] forKey:(__bridge NSString *)(kSecAttrDescription)];
    
    [dictForAdd setValue:@"UUID" forKey:(__bridge id)kSecAttrGeneric];
    
    // Default attributes for keychain item.
    [dictForAdd setObject:@"" forKey:(__bridge id)kSecAttrAccount];
    [dictForAdd setObject:@"" forKey:(__bridge id)kSecAttrLabel];
    
    //
    // The keychain access group attribute determines if this item can be shared
    // amongst multiple apps whose code signing entitlements contain the same keychain access group.
    NSString *accessGroup = [NSString stringWithUTF8String:kKeyChainUDIDAccessGroup];
    if (accessGroup != nil)
    {
#if TARGET_IPHONE_SIMULATOR
        // Ignore the access group if running on the iPhone simulator.
        //
        // Apps that are built for the simulator aren't signed, so there's no keychain access group
        // for the simulator to check. This means that all apps can see all keychain items when run
        // on the simulator.
        //
        // If a SecItem contains an access group attribute, SecItemAdd and SecItemUpdate on the
        // simulator will return -25243 (errSecNoAccessForItem).
#else
        [dictForAdd setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
#endif
    }
    
    const char *udidStr = [udid UTF8String];
    NSData *keyChainItemValue = [NSData dataWithBytes:udidStr length:strlen(udidStr)];
    [dictForAdd setValue:keyChainItemValue forKey:(__bridge id)kSecValueData];
    
    OSStatus writeErr = noErr;
    if ([CHToolKit getUDIDFromKeyChain]) {        // there is item in keychain
        [CHToolKit updateUDIDInKeyChain:udid];
        return YES;
    }
    else {          // add item to keychain
        writeErr = SecItemAdd((__bridge CFDictionaryRef)dictForAdd, NULL);
        if (writeErr != errSecSuccess) {
            NSLog(@"Add KeyChain Item Error!!! Error Code:%d", (int)writeErr);

            return NO;
        }
        else {
            NSLog(@"Add KeyChain Item Success!!!");
            return YES;
        }
    }
    return NO;
}

+ (BOOL)removeUDIDFromKeyChain
{
    NSMutableDictionary *dictToDelete = [[NSMutableDictionary alloc] init];
    
    [dictToDelete setValue:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    NSData *keyChainItemID = [NSData dataWithBytes:kKeychainUDIDItemIdentifier length:strlen(kKeychainUDIDItemIdentifier)];
    [dictToDelete setValue:keyChainItemID forKey:(__bridge id)kSecAttrGeneric];
    
    OSStatus deleteErr = noErr;
    deleteErr = SecItemDelete((__bridge CFDictionaryRef)dictToDelete);
    if (deleteErr != errSecSuccess) {
        NSLog(@"delete UUID from KeyChain Error!!! Error code:%d", (int)deleteErr);
        return NO;
    }
    else {
        NSLog(@"delete success!!!");
    }

    return YES;
}

+ (BOOL)updateUDIDInKeyChain:(NSString*)newUDID
{
    
    NSMutableDictionary *dictForQuery = [[NSMutableDictionary alloc] init];
    
    [dictForQuery setValue:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    NSData *keychainItemID = [NSData dataWithBytes:kKeychainUDIDItemIdentifier
                                            length:strlen(kKeychainUDIDItemIdentifier)];
    [dictForQuery setValue:keychainItemID forKey:(__bridge id)kSecAttrGeneric];
    [dictForQuery setValue:(id)kCFBooleanTrue forKey:(__bridge id)kSecMatchCaseInsensitive];
    [dictForQuery setValue:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [dictForQuery setValue:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
    
    NSDictionary *queryResult = nil;
    SecItemCopyMatching((__bridge CFDictionaryRef)dictForQuery, (void *)&queryResult);
    if (queryResult) {
        
        NSMutableDictionary *dictForUpdate = [[NSMutableDictionary alloc] init];
        [dictForUpdate setValue:[NSString stringWithUTF8String:kKeychainUDIDItemIdentifier] forKey:(__bridge NSString *)(kSecAttrDescription)];
        [dictForUpdate setValue:keychainItemID forKey:(__bridge id)kSecAttrGeneric];
        
        const char *udidStr = [newUDID UTF8String];
        NSData *keyChainItemValue = [NSData dataWithBytes:udidStr length:strlen(udidStr)];
        [dictForUpdate setValue:keyChainItemValue forKey:(__bridge id)kSecValueData];
        
        OSStatus updateErr = noErr;
        
        // First we need the attributes from the Keychain.
        NSMutableDictionary *updateItem = [NSMutableDictionary dictionaryWithDictionary:queryResult];
        
        // Second we need to add the appropriate search key/values.
        // set kSecClass is Very important
        [updateItem setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
        
        updateErr = SecItemUpdate((__bridge CFDictionaryRef)updateItem, (__bridge CFDictionaryRef)dictForUpdate);
        if (updateErr != errSecSuccess) {
            NSLog(@"Update KeyChain Item Error!!! Error Code:%d", (int)updateErr);
    
            return NO;
        }
        else {
            NSLog(@"Update KeyChain Item Success!!!");

            return YES;
        }
    }
    
    return NO;
}
+ (void)swizzleSEL:(SEL)originalSEL withSEL:(SEL)swizzledSEL
{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSEL);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSEL);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSEL,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSEL,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }
    else
    {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
}
#pragma mark Private

+ (BOOL)launchFlag{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *launchKey = [CHToolKit md5FromString:[NSString stringWithFormat:@"%@",[CHToolKit description]]];
//    [defaults removeObjectForKey:[CHToolKit md5FromString:launchKey]];
    if (![defaults objectForKey:launchKey]) {
        [defaults setValue:[CHToolKit description] forKey:launchKey];
        [defaults synchronize];
        return YES;
    }
    return NO;

}

@end
