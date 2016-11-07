//
//  NSError+SignalError.h
//  PhotoBook
//
//  Created by XiaoSong on 15/9/22.
//  Copyright (c) 2015年 侠特科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (SignalError)
+ (NSError *)errorSignal;
+ (NSError *)errorSignalWithDomain:(NSString *)domain
                              code:(NSInteger )code
                           message:(NSString *)message;
@end
