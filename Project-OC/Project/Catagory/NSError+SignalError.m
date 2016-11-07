//
//  NSError+SignalError.m
//  PhotoBook
//
//  Created by XiaoSong on 15/9/22.
//  Copyright (c) 2015年 侠特科技. All rights reserved.
//

#import "NSError+SignalError.h"

@implementation NSError (SignalError)
+ (NSError *)errorSignal{
    NSString *domain = @"Error From errorSignal";
    NSError *error = [[NSError alloc]initWithDomain:domain code:100 userInfo:nil];
    return error;
}
+ (NSError *)errorSignalWithDomain:(NSString *)domain
                              code:(NSInteger )code
                           message:(NSString *)message{
    NSMutableDictionary *info = [[NSMutableDictionary alloc]init];
    if (message) {
        [info setValue:message  forKey:@"message"];
    }
    NSError *error = [[NSError alloc]initWithDomain:domain code:code userInfo:info];
    return error;
}
@end
