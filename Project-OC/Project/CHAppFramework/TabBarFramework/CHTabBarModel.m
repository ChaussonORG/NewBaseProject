//
//  CHTabBarItemModel.m
//  CHTabbarFramework
//
//  Created by 郭金涛 on 16/9/26.
//  Copyright © 2016年 Gjt. All rights reserved.
//

#import "CHTabBarModel.h"
@implementation CHTabBarItemModel
- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        if ([dic objectForKey:@"UIViewControllName"]) {
            self.UIViewControllName = [dic objectForKey:@"UIViewControllName"];
        }else{
            self.UIViewControllName = nil;
        }
        if ([dic objectForKey:@"unselectedIconName"]) {
            self.unselectedIconName = [dic objectForKey:@"unselectedIconName"];
        }else{
            self.unselectedIconName = @"";
        }
        if ([dic objectForKey:@"selectedIconName"]) {
            self.selectedIconName = [dic objectForKey:@"selectedIconName"];
        }else{
            self.selectedIconName = @"";
        }
        if ([dic objectForKey:@"tabbarTitle"]) {
            self.tabbarTitle = [dic objectForKey:@"tabbarTitle"];
        }else{
            self.tabbarTitle = @"";
        }
    }
    return self;
}
@end
@implementation CHTabBarModel
- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        if ([dic objectForKey:@"selectIndex"]) {
            self.selectIndex = [[dic objectForKey:@"selectIndex"] integerValue];
        }else{
            self.selectIndex = 0;
        }
        if ([dic objectForKey:@"tabBarItems"]) {
            self.tabBarItems = [dic objectForKey:@"tabBarItems"];
        }else{
            self.tabBarItems = nil;
        }
        if ([dic objectForKey:@"color"]) {
            self.color = [dic objectForKey:@"color"];
        }else{
            self.color = @"0Xffffff";
        }
        if ([dic objectForKey:@"height"]) {
            self.height = [[dic objectForKey:@"height"] integerValue];
        }else{
            self.height = 50;
        }
    }
    return self;
}
@end
