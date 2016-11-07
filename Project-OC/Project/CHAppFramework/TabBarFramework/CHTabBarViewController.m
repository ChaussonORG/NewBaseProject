//
//  CHTabBarViewController.m
//  CHTabbarFramework
//
//  Created by 郭金涛 on 16/9/26.
//  Copyright © 2016年 Gjt. All rights reserved.
//
#import <Masonry/Masonry.h>

#import "CHTabBarViewController.h"
#import "CHTabBarModel.h"
#import "CHCustomTabBar.h"
#define TABBAR_PLIST_FILENAME @"CHTabBar"
@interface CHTabBarViewController ()<CHCustomTabBarDelegate>
@property (nonatomic, strong)NSMutableArray *tabBarItems;
@property (strong ,nonatomic ) CHCustomTabBar *customTabBar;
@property (nonatomic, strong) CHTabBarModel * model;
@end

@implementation CHTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]){
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    [self getPlistData];
    NSMutableArray *viewcontrollerArray = [[NSMutableArray alloc] initWithCapacity:self.tabBarItems.count];
    for (int i = 0; i < self.tabBarItems.count; i ++) {
        CHTabBarItemModel *item = self.tabBarItems[i];
        Class class = NSClassFromString(item.UIViewControllName);
        [viewcontrollerArray addObject:[[class alloc] init]];
        if (i == self.model.selectIndex) {
            self.title = item.tabbarTitle;
        }
    }
    self.viewControllers = viewcontrollerArray;
    self.selectedIndex = self.model.selectIndex;
    [self.tabBar setHidden:TRUE];
    [self layoutSubviews];

}

- (void)getPlistData{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:TABBAR_PLIST_FILENAME ofType:@"plist"];
    NSDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    self.model = [[CHTabBarModel alloc] initWithDictionary:dic];
    self.tabBarItems = [NSMutableArray array];
    for (NSDictionary *dic in self.model.tabBarItems) {
        CHTabBarItemModel *tabbarModel = [[CHTabBarItemModel alloc] initWithDictionary:dic];
        [self.tabBarItems addObject:tabbarModel];
    }
}
- (void)layoutSubviews{
    self.customTabBar = [[CHCustomTabBar alloc] initWithTabBarItems:self.tabBarItems selectIndex:self.model.selectIndex];
    //实现模糊效果
    self.customTabBar.delegate = self;
    [self.view addSubview:self.customTabBar];
    self.customTabBar.backgroundColor = [self colorWithHexString:self.model.color alpha:1];
    [self.customTabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(0);
        make.left.right.equalTo(self.view).offset(0);
        make.height.equalTo(@(self.model.height));
    }];
}
- (void)selectedIndex:(NSInteger)index title:(NSString *)title
{
    self.selectedIndex = index;
    self.title = title;
}
- (void)tabBarSelectIndex:(NSInteger)index block:(tabBatrBlcok)block{
    [self.customTabBar setSelectIndex:index];
    if (block) {
        block();
    }
}
- (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}
@end
