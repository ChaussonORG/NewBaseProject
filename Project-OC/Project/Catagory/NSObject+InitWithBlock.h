//
//  NSObject+InitWithBlock.h
//  Project
//
//  Created by Chausson on 16/8/15.
//  Copyright © 2016年 Chausson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSObject (InitWithBlock)
- (instancetype)ch_initObject:(void(^)(id <NSObject>obj))block;
@end
