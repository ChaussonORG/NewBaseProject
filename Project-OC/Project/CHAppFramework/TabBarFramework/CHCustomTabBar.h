//
//  CHCustomTabBar.h
//  CHTabbarFramework
//
//  Created by 郭金涛 on 16/9/26.
//  Copyright © 2016年 Gjt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CHCustomTabBarDelegate <NSObject>
- (void)selectedIndex:(NSInteger)index title:(NSString *)title;
@end

@interface CHCustomTabBar : UIView
- (instancetype)initWithTabBarItems:(NSMutableArray *)tabBarItems selectIndex:(NSInteger)selectIndex;
- (void)setSelectIndex:(NSInteger)index;
@property (nonatomic, weak)id<CHCustomTabBarDelegate>delegate;
@end
