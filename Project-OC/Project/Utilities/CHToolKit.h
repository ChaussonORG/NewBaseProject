//
//  CHToolKit.h
//  Project
//
//  Created by Chausson on 16/6/30.
//  Copyright © 2016年 Chausson. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CHToolKit : NSObject
/*
 * @brief 判断是否首次启动APP
 */
+ (BOOL)isFirstLaunch;
/*
 * @brief 转换MD5编码
 */
+ (NSString *)md5FromString:(NSString *)string;
/*
 * @brief obtain Unique Device Identity
 */
+ (NSString*)UDID;//

+ (BOOL)hasUDIDInKeyChain;

+ (BOOL)removeUDIDFromKeyChain;

+ (void)swizzleSEL:(SEL)originalSEL withSEL:(SEL)swizzledSEL; // 方法交换
@end
