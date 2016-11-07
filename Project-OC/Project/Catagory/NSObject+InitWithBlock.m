//
//  NSObject+InitWithBlock.m
//  Project
//
//  Created by Chausson on 16/8/15.
//  Copyright © 2016年 Chausson. All rights reserved.
//

#import "NSObject+InitWithBlock.h"

@implementation NSObject (InitWithBlock)
- (instancetype)ch_initObject:(void(^)(id <NSObject>obj))block{
   
    NSObject *obj = [self init];
    if (block) {
        block(obj);
    }
    
    return obj;
}

@end
