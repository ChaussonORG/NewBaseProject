//
//  CHTabBarViewController.h
//  CHTabbarFramework
//
//  Created by 郭金涛 on 16/9/26.
//  Copyright © 2016年 Gjt. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^tabBatrBlcok)();
@interface CHTabBarViewController : UITabBarController
//自定义跳转方法 带跳转成功后的回调方法
- (void)tabBarSelectIndex:(NSInteger)index block:(tabBatrBlcok)block;

@end
