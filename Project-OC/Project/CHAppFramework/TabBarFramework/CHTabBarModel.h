//
//  CHTabBarItemModel.h
//  CHTabbarFramework
//
//  Created by 郭金涛 on 16/9/26.
//  Copyright © 2016年 Gjt. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CHTabBarItemModel;
@protocol CHTabBarItemModel <NSObject>
@end

@interface CHTabBarItemModel : NSObject
@property (copy ,nonatomic) NSString *UIViewControllName;
@property (copy ,nonatomic) NSString *unselectedIconName;
@property (copy ,nonatomic) NSString *selectedIconName;
@property (copy ,nonatomic) NSString *tabbarTitle;
- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
@interface CHTabBarModel : NSObject
@property (assign ,nonatomic) NSUInteger selectIndex;
@property (strong ,nonatomic) NSArray<CHTabBarItemModel> *tabBarItems;
@property (copy ,nonatomic) NSString *color;
@property (assign ,nonatomic) NSInteger height;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
