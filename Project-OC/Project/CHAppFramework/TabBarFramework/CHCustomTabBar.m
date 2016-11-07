//
//  CHCustomTabBar.m
//  CHTabbarFramework
//
//  Created by 郭金涛 on 16/9/26.
//  Copyright © 2016年 Gjt. All rights reserved.
//
#import <Masonry/Masonry.h>
#import "CHCustomTabBar.h"
#import "CHTabBarModel.h"
#define KIndexCount 10
@interface CHCustomTabBar()
@property (nonatomic, strong)NSMutableArray *tabBarItems;
@property (nonatomic, assign)NSInteger index;

@end

@implementation CHCustomTabBar
- (instancetype)initWithTabBarItems:(NSMutableArray *)tabBarItems selectIndex:(NSInteger)selectIndex
{
    self = [super init];
    if (self) {
        self.tabBarItems = tabBarItems;
        self.index = selectIndex;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    for (NSInteger i = 0; i < self.tabBarItems.count; i++) {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        CHTabBarItemModel *batItemViewModel =  self.tabBarItems[i];
        
        [button setImage:[UIImage imageNamed:batItemViewModel.unselectedIconName] forState:(UIControlStateNormal)];
        [button setAdjustsImageWhenHighlighted:NO];
        // button.backgroundColor = [UIColor blueColor];
        [button setImage:[UIImage imageNamed:batItemViewModel.selectedIconName] forState:(UIControlStateSelected)];
        button.tag = i+KIndexCount;
        [button addTarget:self action:@selector(customButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        button.layer.masksToBounds = YES;
        if (i == self.index) {
            button.selected = YES;
        }
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(0);
            make.left.equalTo(self).offset([UIScreen mainScreen].bounds.size.width / self.tabBarItems.count * i );
            make.height.equalTo(@50);
            make.width.equalTo(@([UIScreen mainScreen].bounds.size.width / self.tabBarItems.count));
        }];
//        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
//        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0f constant:50];
//         NSLayoutConstraint *widht = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0f  constant:[UIScreen mainScreen].bounds.size.width / self.tabBarItems.count];
//        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0f  constant:[UIScreen mainScreen].bounds.size.width / self.tabBarItems.count * i];
////        bottom.active = YES;
////        height.active = YES;
////        widht.active = YES;
////        left.active = YES;
//        [self addConstraint:left];
//        [button addConstraint:height];
//        [self addConstraint:bottom];
//        [button addConstraint:widht];
    }
}
- (void)customButtonAction:(UIButton *)button{
    [self setSelectIndex:button.tag - KIndexCount];
}
- (void)setSelectIndex:(NSInteger)index{
    UIButton *desBtn = (UIButton *)[self viewWithTag:self.index + KIndexCount];
    UIButton *currentBtn = (UIButton *)[self viewWithTag:index + KIndexCount];
    desBtn.selected = NO;
    currentBtn.selected = YES;
    self.index = index;
    CHTabBarItemModel *batItemViewModel =  self.tabBarItems[index];
    [self.delegate selectedIndex:index title:batItemViewModel.tabbarTitle];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
